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
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var directionsView: UIView!
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
    var image: UIImage?
    var ingredient: Ingredient?
    var direction: Direction?
    var ingredients: [Ingredient] = []
    var directions: [Direction] = []
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = recipeNameTextField.text, !name.isEmpty,
              let image = photoImageView.image?.jpegData(compressionQuality: 0.5) else { return }
        if let recipe = recipe {
            RecipeController.shared.updateRecipe(recipe: recipe, name: name, image: image)
        } else if let recipe = recipe, photoImageView.image == nil {
            let image = UIImage(named: "food-default")?.jpegData(compressionQuality: 0.5)
            RecipeController.shared.createRecipeWith(name: name, image: image)
        } else {
            RecipeController.shared.createRecipeWith(name: name, image: image)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if recipeSegmentControl.selectedSegmentIndex == 0 {
            addIngredientToTable()
        } else {
            addDirectionsToTable()
        }
        recipeItemTextField.text = ""
    }
    
    @IBAction func recipeSegmentedController(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            recipeItemTextField.placeholder = "Enter Ingredient..."
            ingredientsView.alpha = 1
            directionsView.alpha = 0
        case 1:
            recipeItemTextField.placeholder = "Enter Direction..."
            ingredientsView.alpha = 0
            directionsView.alpha = 1
        default:
            recipeItemTextField.placeholder = ""
            ingredientsView.alpha = 0
            directionsView.alpha = 0
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
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func addIngredientToTable() {
        guard let recipe = recipe,
              let ingredient = recipeItemTextField.text, !ingredient.isEmpty else { return }
        IngredientController.shared.createIngredientWith(name: ingredient, recipe: recipe)
    }
    
    func addDirectionsToTable() {
        guard let recipe = recipe,
              let direction = recipeItemTextField.text, !direction.isEmpty else { return }
        DirectionController.shared.addDirectionTo(recipe: recipe, direction: direction)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPicker" {
            let destination = segue.destination as? PhotoPickerViewController
            destination?.delegate = self
        }
        if segue.identifier == "ingredientsTableView" {
            let destination = segue.destination as? IngredientsListViewController
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

extension RecipeDetailViewController: IngredientsTableViewDelegate {
    func tableViewLoaded(recipe: Recipe) {
        self.recipe = recipe
    }
}//End of Extension
