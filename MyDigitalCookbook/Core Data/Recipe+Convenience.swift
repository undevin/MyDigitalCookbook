//
//  Recipe+Convenience.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/22/21.
//

import CoreData

extension Recipe {
    @discardableResult convenience init(name: String, ingredients: String, directions: String, uuid: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.ingredients = ingredients
        self.directions = directions
        self.uuid = uuid
    }
    
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}//End of Extension
