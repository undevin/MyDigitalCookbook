//
//  DirectionController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/27/21.
//

import CoreData

class DirectionController {
    
    // MARK: - Properties
    static let shared = DirectionController()
    var directions: [Direction] = []
    
    private lazy var fetchRequest: NSFetchRequest<Direction> = {
        let request = NSFetchRequest<Direction>(entityName: "Direction")
        request.relationshipKeyPathsForPrefetching = ["recipe"]
        return request
    }()
    
    // MARK: - Methods
    func addDirectionTo(recipe: Recipe, direction: String) {
        let newDirection = Direction(directions: direction, recipe: recipe)
        directions.append(newDirection)
        CoreDataStack.saveContext()
    }
    
    func fetchDirections(predicate: NSPredicate = NSPredicate(value: true)) {
        self.fetchRequest.predicate = predicate
        self.directions = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    func updateDirection(directions: String, direction: Direction) {
        direction.directions = directions
        CoreDataStack.saveContext()
    }
    
    func deleteDirection(name: Direction) {
        guard let index = directions.firstIndex(of: name) else { return }
        directions.remove(at: index)
        CoreDataStack.context.delete(name)
        CoreDataStack.saveContext()
    }
}//End of Class
