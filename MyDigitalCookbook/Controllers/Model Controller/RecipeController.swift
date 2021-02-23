//
//  RecipeController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/22/21.
//

import CoreData

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
        Recipe(name: name, ingredients: ingredients, directions: directions)
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
}//End of Class

