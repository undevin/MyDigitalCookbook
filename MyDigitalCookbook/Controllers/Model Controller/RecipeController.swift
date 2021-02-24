//
//  RecipeController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/22/21.
//

import CoreData
import UIKit

class RecipeController {
    
    // MARK: - Properties
    static let shared = RecipeController()
    var recipes: [Recipe] = []
    
    private lazy var fetchRequest: NSFetchRequest<Recipe> = {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - Methods
    func createRecipeWith(name: String, ingredients: String, directions: String) {
        let newRecipe = Recipe(name: name, ingredients: ingredients, directions: directions)
        recipes.append(newRecipe)
        CoreDataStack.saveContext()
    }
    
    func fetchRecipes() {
        self.recipes = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    func updateRecipe(recipe: Recipe, name: String, ingredients: String, directions: String) {
        recipe.name = name
        recipe.ingredients = ingredients
        recipe.directions = directions
        CoreDataStack.saveContext()
    }
    
    func deleteRecipe(recipe: Recipe) {
        CoreDataStack.context.delete(recipe)
        CoreDataStack.saveContext()
        fetchRecipes()
    }
    
    func saveImage(recipe: Recipe, image: UIImage) {
        let imageData = image.jpegData(compressionQuality: 0.5)
        recipe.image?.image = imageData
        CoreDataStack.saveContext()
    }
    
    func loadImage(recipe: Recipe) -> UIImage {
        guard let imageData = recipe.image?.image else { return UIImage(named: "food-default")! }
        let image = UIImage(data: imageData)
        return image ?? UIImage(named: "food-default")!
    }
    
}//End of Class

