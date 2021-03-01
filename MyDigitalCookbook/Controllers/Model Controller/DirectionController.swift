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
    
    private lazy var fetchRequest: NSFetchRequest<Direction> = {
        let request = NSFetchRequest<Direction>(entityName: "Direction")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - Methods
    func addDirectionTo(recipe: Recipe, direction: String) {
        Direction(directions: direction, recipe: recipe)
        CoreDataStack.saveContext()
    }
    
    func updateDirection(directions: String, direction: Direction) {
        direction.directions = directions
        CoreDataStack.saveContext()
    }
}//End of Class
