//
//  Ingredients+Convenience.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/26/21.
//

import CoreData

extension Ingredient {
    @discardableResult convenience init(name: String, recipe: Recipe, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.recipe = recipe
    }
    
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name
    }
}//End of Extension
