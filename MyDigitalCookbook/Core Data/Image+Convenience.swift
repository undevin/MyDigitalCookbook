//
//  Image+Convenience.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/23/21.
//

import CoreData

extension Image {
    @discardableResult convenience init(image: Data, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.image = image
    }
}//End of Extension
