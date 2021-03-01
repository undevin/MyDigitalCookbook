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
    
    private lazy var fetchRequest: NSFetchRequest<Ingredient> = {
        let request = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - Methods
    func createIngredientWith(name: String, recipe: Recipe) {
        Ingredient(name: name, recipe: recipe)
        CoreDataStack.saveContext()
    }
    
    func updateIngredient(name: String, ingredient: Ingredient) {
        ingredient.name = name
        CoreDataStack.saveContext()
    }
}//End of Class
