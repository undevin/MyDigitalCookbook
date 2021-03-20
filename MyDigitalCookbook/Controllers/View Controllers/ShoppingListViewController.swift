//
//  ShoppingListViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 3/19/21.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ShoppingListController.shared.fetchShoppingList()
    }
    
    // MARK: - Properties
    var refresher: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        showAlertController()
    }
    
    // MARK: - Methods
    func setupViews() {
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh list!")
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresher)
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func loadData() {
        ShoppingListController.shared.fetchShoppingList()
        tableView.reloadData()
        self.refresher.endRefreshing()
    }
    
    func showAlertController() {
        let alertController = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        let addButton = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let newItem = alertController.textFields?[0].text, !newItem.isEmpty else { return }
            ShoppingListController.shared.createItemWith(name: newItem, purchased: false)
            self.tableView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (_) in }
        alertController.addAction(addButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
}//End of Class

// MARK: - Extensions
extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingListController.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as? ShoppingListTableViewCell else { return UITableViewCell() }
        let shoppingItem = ShoppingListController.shared.items[indexPath.row]
        cell.updateView(item: shoppingItem)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = ShoppingListController.shared.items[indexPath.row]
            ShoppingListController.shared.deleteItem(item: itemToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}//End of Extension

extension ShoppingListViewController: ShoppingListViewCellDelegate {
    func buttonTapped(cell: ShoppingListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let itemToToggle = ShoppingListController.shared.items[indexPath.row]
        ShoppingListController.shared.updateItemPurchased(item: itemToToggle)
        cell.updateView(item: itemToToggle)
    }
}//End of Extension
