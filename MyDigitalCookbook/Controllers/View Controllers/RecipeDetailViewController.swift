//
//  RecipeDetailViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/26/21.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var recipeItemTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var recipeSegmentControl: UISegmentedControl!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Properties
    var recipe: Recipe? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = recipeNameTextField.text, !name.isEmpty,
              let image = photoImageView.image?.jpegData(compressionQuality: 0.5) else { return }
        if let recipe = recipe {
            RecipeController.shared.updateRecipe(recipe: recipe, name: name, image: image)
        } else {
            RecipeController.shared.createRecipeWith(name: name, image: image)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        addItemToTable()
        recipeItemTextField.text = ""
    }
    
    @IBAction func recipeSegmentedController(_ sender: UISegmentedControl) {
        guard let recipe = recipe else { return }
        switch sender.selectedSegmentIndex {
        case 0:
            IngredientController.shared.fetchIngredients(predicate: NSPredicate(format: "recipe == %@", recipe))
            recipeItemTextField.placeholder = "Enter Ingredient..."
            tableView.reloadData()
        case 1:
            DirectionController.shared.fetchDirections(predicate: NSPredicate(format: "recipe == %@", recipe))
            recipeItemTextField.placeholder = "Enter Direction..."
            tableView.reloadData()
        default:
            recipeItemTextField.placeholder = ""
            tableView.reloadData()
        }
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let recipe = recipe,
              let image = recipe.image else { return }
        recipeNameTextField.text = recipe.name
        self.title = recipe.name
        photoImageView.image = UIImage(data: image)
    }
    
    func setupViews() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        recipeNameTextField.resignFirstResponder()
        recipeItemTextField.resignFirstResponder()
        view.addGestureRecognizer(tap)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.isEditing = true
        addButton.layer.cornerRadius = 10
        guard let recipe = recipe else { return }
        IngredientController.shared.fetchIngredients(predicate: NSPredicate(format: "recipe == %@", recipe))
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func addItemToTable() {
        if recipeSegmentControl.selectedSegmentIndex == 0 {
            guard let recipe = recipe,
                  let name = recipeItemTextField.text, !name.isEmpty else { return }
            IngredientController.shared.addIngredientWith(name: name, recipe: recipe)
        } else {
            guard let recipe = recipe,
                  let direction = recipeItemTextField.text, !direction.isEmpty else { return }
            DirectionController.shared.addDirectionTo(recipe: recipe, direction: direction)
        }
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPicker" {
            let destination = segue.destination as? PhotoPickerViewController
            destination?.delegate = self
        }
    }
}//End of Class

// MARK: - Extensions
extension RecipeDetailViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.photoImageView.image = image
    }
}//End of Extension

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipeSegmentControl.selectedSegmentIndex == 0 {
            return IngredientController.shared.ingredients.count
        } else {
            return DirectionController.shared.directions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if recipeSegmentControl.selectedSegmentIndex == 0 {
            let ingredient = IngredientController.shared.ingredients[indexPath.row]
            cell.textLabel?.text = ingredient.name
            cell.textLabel?.numberOfLines = 0
            return cell
        } else {
            let direction = DirectionController.shared.directions[indexPath.row]
            cell.textLabel?.text = direction.directions
            cell.textLabel?.numberOfLines = 0
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch recipeSegmentControl.selectedSegmentIndex {
        case 0:
            if editingStyle == .delete {
                let ingredient = IngredientController.shared.ingredients[indexPath.row]
                IngredientController.shared.deleteIngredient(name: ingredient)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case 1:
            if editingStyle == .delete {
                let direction = DirectionController.shared.directions[indexPath.row]
                DirectionController.shared.deleteDirection(name: direction)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            let alert = UIAlertController(title: "Error", message: "Unable to delete. Please try again.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if recipeSegmentControl.selectedSegmentIndex == 0 {
            let moved = IngredientController.shared.ingredients[sourceIndexPath.row]
            IngredientController.shared.ingredients.remove(at: sourceIndexPath.row)
            IngredientController.shared.ingredients.insert(moved, at: destinationIndexPath.row)
        } else {
            let moved = DirectionController.shared.directions[sourceIndexPath.row]
            DirectionController.shared.directions.remove(at: sourceIndexPath.row)
            DirectionController.shared.directions.insert(moved, at: destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}//End of Extension
