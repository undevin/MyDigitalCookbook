//
//  IngredientListTableViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/28/21.
//

import UIKit

protocol IngredientTableViewDelegate: AnyObject {
    func tableViewLoaded(recipe: Recipe)
}

class IngredientListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    // MARK: - Properties
    var recipe: Recipe?
    var ingredients: Ingredient?
    weak var delegate: IngredientTableViewDelegate?

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let name = ingredients?.name
        cell.textLabel?.text = name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}//End of Class
