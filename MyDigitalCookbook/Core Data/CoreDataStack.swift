//
//  CoreDataStack.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/22/21.
//

import CoreData

enum CoreDataStack {
    
    static let container: NSPersistentCloudKitContainer = {
        
        let container = NSPersistentCloudKitContainer(name: "MyDigitalCookbook")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading persistent store; \(error)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { container.viewContext }
    
    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}//End of Enum

