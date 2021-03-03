//
//  DirectionsListViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 3/2/21.
//

import UIKit

protocol DirectionTableViewDelegate: AnyObject {
    func directionTableViewLoaded(recipe: Recipe)
}

class DirectionsListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Properties
    weak var delegate: DirectionTableViewDelegate?
    var recipe: Recipe?
    var direction: Direction?
    
    
    //MARK: - Methods
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}//End of Class

// MARK: - Extensions
extension DirectionsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DirectionController.shared.directions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "directionCell", for: indexPath)
        let name = DirectionController.shared.directions[indexPath.row].directions
        cell.textLabel?.text = name
        
        return cell
    }
}//End of Extension
