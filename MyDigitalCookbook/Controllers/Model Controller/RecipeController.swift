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
    func createRecipeWith(name: String, image: Data?) {
        guard let image = image else { return }
        let newRecipe = Recipe(name: name, image: image)
        recipes.append(newRecipe)
        CoreDataStack.saveContext()
    }
    
    func fetchRecipes() {
        self.recipes = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    func updateRecipe(recipe: Recipe, name: String, image: Data?) {
        guard let image = image else { return }
        recipe.name = name
        recipe.image = image
        CoreDataStack.saveContext()
    }
    
    func deleteRecipe(recipe: Recipe) {
        guard let index = recipes.firstIndex(of: recipe) else { return }
        recipes.remove(at: index)
        CoreDataStack.context.delete(recipe)
        CoreDataStack.saveContext()
        fetchRecipes()
    }
    
    func addIngredientTo(recipe: Recipe, ingredient: Ingredient) {
        recipe.ingredients?.addingObjects(from: [ingredient])
        CoreDataStack.saveContext()
    }
    
    func addDirectionsTo(recipe: Recipe, direction: Direction) {
        recipe.directions?.addingObjects(from: [direction])
        CoreDataStack.saveContext()
    }
}//End of Class
