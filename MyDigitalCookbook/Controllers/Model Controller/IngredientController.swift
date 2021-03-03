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
    var ingredients: [Ingredient] = []
    
    private lazy var fetchRequest: NSFetchRequest<Ingredient> = {
        let request = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        request.predicate = NSPredicate(value: true)
//        request.predicate = NSPredicate(format: "name == %@", "TEST")
        return request
    }()
    
    // MARK: - Methods
    func addIngredientWith(name: String, recipe: Recipe) {
        Ingredient(name: name, recipe: recipe)
        CoreDataStack.saveContext()
    }
    
    func fetchIngredients() {
        self.ingredients = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    func updateIngredient(name: String, ingredient: Ingredient) {
        ingredient.name = name
        CoreDataStack.saveContext()
    }
    
    func deleteIngredient(name: Ingredient) {
        guard let index = ingredients.firstIndex(of: name) else { return }
        ingredients.remove(at: index)
        CoreDataStack.context.delete(name)
        CoreDataStack.saveContext()
    }
}//End of Class
