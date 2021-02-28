//
//  Vision+Convenience.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/25/21.
//

import CoreData

extension Vision {
    @discardableResult convenience init(name: String, image: Data, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.image = image
    }
}//End of Extension
