//
//  RecipeListViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/26/21.
//

import UIKit

class RecipeListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RecipeController.shared.fetchRecipes()
        tableView.reloadData()
    }
    
    // MARK: - Properties
    var refresher: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Methods
    func setupViews() {
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh recipes!")
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresher)
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func loadData() {
        RecipeController.shared.fetchRecipes()
        tableView.reloadData()
        self.refresher.endRefreshing()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? RecipeDetailViewController else { return }
            let recipeToSend = RecipeController.shared.recipes[indexPath.row]
            destination.recipe = recipeToSend
        }
    }
}//End of Class

// MARK: - Extensions
extension RecipeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RecipeController.shared.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {return UITableViewCell()}
        let recipe = RecipeController.shared.recipes[indexPath.row]
        cell.recipe = recipe
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipeToDelete = RecipeController.shared.recipes[indexPath.row]
            RecipeController.shared.deleteRecipe(recipe: recipeToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}//End of Extension
