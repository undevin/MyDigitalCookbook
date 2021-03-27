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
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RecipeController.shared.fetchRecipes()
        resultsArray = RecipeController.shared.recipes
        tableView.reloadData()
    }
    
    // MARK: - Properties
    var refresher: UIRefreshControl = UIRefreshControl()
    let defaultImage: UIImage = UIImage(named: "food-default")!
    var isSearching = false
    var resultsArray: [SearchableRecordDelegate] = []
    
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
        searchBar.delegate = self
        
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
            textfield.autocapitalizationType = .words
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let create = UIAlertAction(title: "Create", style: .default) { [weak self] (_) in
            guard let name = alertController.textFields?[0].text,
                  let image = self?.defaultImage.jpegData(compressionQuality: 0.5) else { return }
            RecipeController.shared.createRecipeWith(name: name, image: image)
            self?.resultsArray = RecipeController.shared.recipes
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
        resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {return UITableViewCell()}
        let recipe = resultsArray[indexPath.row]
        cell.recipe = recipe as? Recipe
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipeToDelete = resultsArray[indexPath.row]
            guard let recipe = recipeToDelete as? Recipe else { return }
            RecipeController.shared.deleteRecipe(recipe: recipe)
            resultsArray = RecipeController.shared.recipes
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}//End of Extension

extension RecipeListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            resultsArray = RecipeController.shared.recipes.filter{ $0.matches(searchTerm: searchText)}
            self.tableView.reloadData()
        } else {
            resultsArray = RecipeController.shared.recipes
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.searchBar.showsCancelButton = false
        isSearching = false
        resultsArray = RecipeController.shared.recipes
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}//End of Extension
