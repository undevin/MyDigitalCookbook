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
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VisionController.shared.fetchVisionRecipes()
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
        VisionController.shared.visionRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "visionRecipeCell", for: indexPath)
        let visionRecipe = VisionController.shared.visionRecipes[indexPath.row]
        cell.textLabel?.text = visionRecipe.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipeToDelete = VisionController.shared.visionRecipes[indexPath.row]
            VisionController.shared.deleteVisionRecipe(visionRecipe: recipeToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}//End of Extension
