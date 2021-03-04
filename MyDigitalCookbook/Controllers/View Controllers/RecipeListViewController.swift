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
    let defaultImage: UIImage = UIImage(named: "food-default")!
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        createNewRecipe()
    }
    
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
    
    func createNewRecipe() {
        let alertController = UIAlertController(title: "Add New Recipe", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Recipe Name"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let create = UIAlertAction(title: "Create", style: .default) { [weak self] (_) in
            guard let name = alertController.textFields?[0].text,
                  let image = self?.defaultImage.jpegData(compressionQuality: 0.5) else { return }
            RecipeController.shared.createRecipeWith(name: name, image: image)
            self?.tableView.reloadData()
        }
        alertController.addAction(cancel)
        alertController.addAction(create)
        present(alertController, animated: true, completion: nil)
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
