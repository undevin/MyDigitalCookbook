//
//  VisionController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/25/21.
//

import CoreData

class VisionController {
    
    // MARK: - Properties
    static let shared = VisionController()
    var visionRecipes: [Vision] = []
    
    private lazy var fetchRequest: NSFetchRequest<Vision> = {
        let request = NSFetchRequest<Vision>(entityName: "Vision")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - Methods
    func createVisionRecipe(name: String, image: Data) {
        let newRecipe = Vision(name: name, image: image)
        visionRecipes.append(newRecipe)
        CoreDataStack.saveContext()
    }
    
    func fetchVisionRecipes() {
        self.visionRecipes = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    func updateVisionRecipe(visionRecipe: Vision, name: String, image: Data) {
        visionRecipe.name = name
        visionRecipe.image = image
        CoreDataStack.saveContext()
    }
    
    func deleteVisionRecipe(visionRecipe: Vision) {
        guard let index = visionRecipes.firstIndex(of: visionRecipe) else { return }
        visionRecipes.remove(at: index)
        CoreDataStack.context.delete(visionRecipe)
        CoreDataStack.saveContext()
        fetchVisionRecipes()
    }
}//End of Class
