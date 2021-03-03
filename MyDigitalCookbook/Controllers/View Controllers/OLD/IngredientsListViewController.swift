//
//  IngredientsListViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 3/1/21.
//

import UIKit

protocol IngredientsTableViewDelegate: AnyObject {
    func ingredientTableViewLoaded(ingredients: [Ingredient])
}

class IngredientsListViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Properties
    weak var delegate: IngredientsTableViewDelegate?
    var recipe: Recipe?
    var ingredients: [Ingredient] = []
    
    //MARK: - Methods
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        guard let recipe = recipe else { return }
        IngredientController.shared.fetchIngredients()
    }
}//End of Class

//MARK: - Extensions
extension IngredientsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientController.shared.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let ingredient = IngredientController.shared.ingredients[indexPath.row]
        cell.textLabel?.text = ingredient.name
        
        return cell
    }
}//End of Extension
