//
//  IngredientsListViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 3/1/21.
//

import UIKit

protocol IngredientsTableViewDelegate: AnyObject {
    func tableViewLoaded(recipe: Recipe)
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
    var ingredient: Ingredient?
    
    //MARK: - Methods
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}//End of Class

//MARK: - Extensions
extension IngredientsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let name = ingredient?.name
        cell.textLabel?.text = name
        
        return cell
    }
}//End of Extension
