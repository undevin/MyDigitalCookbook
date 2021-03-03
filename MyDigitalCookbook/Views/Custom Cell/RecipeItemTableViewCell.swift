//
//  RecipeItemTableViewCell.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 3/2/21.
//

import UIKit

class RecipeItemTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var recipeItemLabel: UILabel!
    
    // MARK: - Properties
    var recipe: Recipe?
    var ingredient: Ingredient?
    var directions: Direction?
    
    // MARK: - Methods
    func updateViews() {
        guard let recipe = recipe,
              let ingredient = ingredient,
              let directions = directions else { return }
        
    }
}//End of Class
