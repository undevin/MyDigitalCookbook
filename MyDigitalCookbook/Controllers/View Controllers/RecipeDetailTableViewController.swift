//
//  RecipeDetailTableViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/22/21.
//

import UIKit

class RecipeDetailTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var directionsTextView: UITextView!
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - Properties
    var recipe: Recipe?
    var image: UIImage?
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = recipeNameTextField.text, !name.isEmpty,
              let ingredients = ingredientsTextView.text,
              let directions = directionsTextView.text,
              let image = image?.jpegData(compressionQuality: 0.5) else { return }
        if let recipe = recipe {
            RecipeController.shared.updateRecipe(recipe: recipe, name: name, ingredients: ingredients, directions: directions, image: image)
        } else {
            RecipeController.shared.createRecipeWith(name: name, ingredients: ingredients, directions: directions, image: image)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let recipe = recipe,
              let image = recipe.image else { return }
        recipeNameTextField.text = recipe.name
        ingredientsTextView.text = recipe.ingredients
        directionsTextView.text = recipe.directions
        photoImageView.image = UIImage(data: image)
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
extension RecipeDetailTableViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}//End of Extension
