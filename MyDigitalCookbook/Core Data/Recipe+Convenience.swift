//
//  Recipe+Convenience.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/22/21.
//

import CoreData

//MARK: - Protocols
protocol SearchableRecordDelegate {
    func matches(searchTerm: String) -> Bool
}//End of protocol

extension Recipe {
    @discardableResult convenience init(name: String, uuid: String = UUID().uuidString, image: Data?, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.uuid = uuid
        self.image = image
    }
    
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}//End of Extension
