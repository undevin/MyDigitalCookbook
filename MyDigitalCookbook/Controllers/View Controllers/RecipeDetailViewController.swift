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
//    @IBOutlet weak var ingredientView: UIView!
//    @IBOutlet weak var directionsView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    
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
    var emptyArray: [String] = []
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = recipeNameTextField.text, !name.isEmpty,
              let image = photoImageView.image?.jpegData(compressionQuality: 0.5) else { return }
        if let recipe = recipe {
            RecipeController.shared.updateRecipe(recipe: recipe, name: name, image: image)
        } else {
            if photoImageView.image != nil {
                RecipeController.shared.createRecipeWith(name: name, image: image)
            } else {
                let image = UIImage(named: "food-default")?.jpegData(compressionQuality: 0.5)
                RecipeController.shared.createRecipeWith(name: name, image: image)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func recipeSegmentedController(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            recipeItemTextField.placeholder = "Enter Ingredient..."
        case 1:
            recipeItemTextField.placeholder = "Enter Direction..."
        default:
            recipeItemTextField.placeholder = ""
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPicker" {
            let destination = segue.destination as? PhotoPickerViewController
            destination?.delegate = self
        }
        if segue.identifier == "ingredientsTableView" {
            let destination = segue.destination as? IngredientListTableViewController
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

extension RecipeDetailViewController: IngredientTableViewDelegate {
    func tableViewLoaded(recipe: Recipe) {
        self.recipe?.ingredients = recipe.ingredients
    }
}//End of Extension
