//
//  Shopping+Convenience.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 3/18/21.
//

import CoreData

extension Shopping {
    @discardableResult convenience init(name: String, purchased: Bool, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.purchased = purchased
    }
}//End of Extension
