//
//  RecipeVisonListViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/26/21.
//

import UIKit

class VisionRecipeListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VisionController.shared.fetchVisionRecipes()
        visionResultsArray = VisionController.shared.visionRecipes
        tableView.reloadData()
    }
    
    // MARK: - Properties
    var refresher: UIRefreshControl = UIRefreshControl()
    var visionIsSearching = false
    var visionResultsArray: [SearchableVisionRecordDelegate] = []
    
    // MARK: - Methods
    func setupViews() {
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh recipes!")
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresher)
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @objc func loadData() {
        RecipeController.shared.fetchRecipes()
        tableView.reloadData()
        self.refresher.endRefreshing()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVisionRecipeDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? VisionRecipeDetailViewController else { return }
            let visionRecipeToSend = VisionController.shared.visionRecipes[indexPath.row]
            destination.visionRecipe = visionRecipeToSend
        }
    }
}//End of Class

// MARK: - Extensions
extension VisionRecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visionResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "visionRecipeCell", for: indexPath)
        let visionRecipe = visionResultsArray[indexPath.row]
        let visionName = visionRecipe as? Vision
        cell.textLabel?.text = visionName?.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipeToDelete = visionResultsArray[indexPath.row]
            guard let visionRecipe = recipeToDelete as? Vision else { return }
            VisionController.shared.deleteVisionRecipe(visionRecipe: visionRecipe)
            visionResultsArray = VisionController.shared.visionRecipes
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}//End of Extension

extension VisionRecipeListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            visionResultsArray = VisionController.shared.visionRecipes.filter{ $0.matches(searchTerm: searchText)}
            self.tableView.reloadData()
        } else {
            visionResultsArray = VisionController.shared.visionRecipes
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        visionIsSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.searchBar.showsCancelButton = false
        visionIsSearching = false
        visionResultsArray = VisionController.shared.visionRecipes
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        visionIsSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        visionIsSearching = false
    }
}//End of Extension
