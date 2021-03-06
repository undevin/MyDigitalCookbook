//
//  Directions+Convenience.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/26/21.
//

import CoreData

extension Direction {
    @discardableResult convenience init(directions: String, date: Date = Date(), recipe: Recipe, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.directions = directions
        self.date = date
        self.recipe = recipe
    }
    
    static func ==(lhs: Direction, rhs: Direction) -> Bool {
        return lhs.directions == rhs.directions
    }
}//End of Extension
