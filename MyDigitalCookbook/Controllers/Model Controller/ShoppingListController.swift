//
//  ShoppingListController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 3/19/21.
//

import CoreData

class ShoppingListController {
    
    // MARK: - Properties
    static let shared = ShoppingListController()
    var items: [Shopping] = []
    
    private lazy var fetchRequest: NSFetchRequest<Shopping> = {
        let request = NSFetchRequest<Shopping>(entityName: "Shopping")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - Methods
    func createItemWith(name: String, purchased: Bool) {
        let newItem = Shopping(name: name, purchased: purchased)
        items.append(newItem)
        CoreDataStack.saveContext()
    }
    
    func fetchShoppingList() {
        self.items = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    func updateItemPurchased(item: Shopping) {
        item.purchased.toggle()
        CoreDataStack.saveContext()
    }
    
    func deleteItem(item: Shopping) {
        guard let index = items.firstIndex(of: item) else { return }
        items.remove(at: index)
        CoreDataStack.context.delete(item)
        CoreDataStack.saveContext()
    }
}//End of Class
