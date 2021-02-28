//
//  IngredientController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/27/21.
//

import CoreData

class IngredientController {
    
    // MARK: - Properties
    static let shared = IngredientController()
    
    private lazy var fetchRequest: NSFetchRequest<Recipe> = {
        let request = NSFetchRequest<Recipe>(entityName: "Ingredient")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - Methods
    func createIngredientWith(name: String, recipe: Recipe) {
        let ingredient = Ingredient(name: name, recipe: recipe)
        RecipeController.shared.addIngredientTo(recipe: recipe, ingredient: ingredient)
    }
    
    func fetchingredients() {
        RecipeController.shared.recipes = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    func updateIngredient(name: String, ingredient: Ingredient) {
        ingredient.name = name
        CoreDataStack.saveContext()
    }
}//End of Class
