//
//  RecipeListTableViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/22/21.
//

import UIKit

class RecipeListTableViewController: UITableViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RecipeController.shared.fetchRecipes()
    }
    
    // MARK: - Properties
    var refresher: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Methods
    func setupView() {
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh recipes!")
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresher)
    }
    
    @objc func loadData() {
        RecipeController.shared.fetchRecipes()
        tableView.reloadData()
        self.refresher.endRefreshing()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeController.shared.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }
        let recipe = RecipeController.shared.recipes[indexPath.row]
        
        cell.recipe = recipe
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipeToDelete = RecipeController.shared.recipes[indexPath.row]
            RecipeController.shared.deleteRecipe(recipe: recipeToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? RecipeDetailTableViewController else { return }
            let recipeToSend = RecipeController.shared.recipes[indexPath.row]
            destination.recipe = recipeToSend
        }
    }
}//End of Class
