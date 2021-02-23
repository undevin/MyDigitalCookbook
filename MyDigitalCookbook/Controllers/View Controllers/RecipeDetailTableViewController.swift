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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Properties
    var recipe: Recipe?
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = recipeNameTextField.text, !name.isEmpty,
              let ingredients = ingredientsTextView.text, !ingredients.isEmpty,
              let directions = directionsTextView.text, !directions.isEmpty else { return }
        if let recipe = recipe {
            RecipeController.shared.updateRecipe(recipe: recipe, name: name, ingredients: ingredients, directions: directions)
        } else {
            RecipeController.shared.createRecipeWith(name: name, ingredients: ingredients, directions: directions)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let recipe = recipe else { return }
        recipeNameTextField.text = recipe.name
        ingredientsTextView.text = recipe.ingredients
        directionsTextView.text = recipe.directions
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}//End of Class
