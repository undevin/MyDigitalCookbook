//
//  RecipeTableViewCell.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/22/21.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    // MARK: - Properties
    var recipe: Recipe? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let recipe = recipe else { return }
        recipeNameLabel.text = recipe.name
        guard let image = recipe.image else { return }
        recipeImageView.image = UIImage(data: image) ?? UIImage(named: "food-default")
    }
}//End of Class
