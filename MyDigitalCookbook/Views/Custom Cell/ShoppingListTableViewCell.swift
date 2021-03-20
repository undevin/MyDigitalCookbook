//
//  ShoppingListTableViewCell.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 3/18/21.
//

import UIKit

// MARK: - Protocol
protocol ShoppingListViewCellDelegate: AnyObject {
    func buttonTapped(cell: ShoppingListTableViewCell)
}

class ShoppingListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var itemButton: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    
    // MARK: - Properties
    weak var delegate: ShoppingListViewCellDelegate?
    
    // MARK: - Actions
    @IBAction func itemButtonTapped(_ sender: UIButton) {
        delegate?.buttonTapped(cell: self)
    }
    
    // MARK: - Methods
    func updateView(item: Shopping) {
        itemNameLabel.text = item.name
        updateItemPurchasedButton(purchased: item.purchased)
        updateItemTextColor(item: item)
    }
    
    func updateItemPurchasedButton(purchased: Bool) {
        let image = purchased ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        itemButton.setImage(image, for: .normal)
    }
    
    func updateItemTextColor(item: Shopping) {
        if item.purchased {
            itemNameLabel.textColor = .systemGray2
        } else {
            itemNameLabel.textColor = .systemGray
        }
    }
}//End of Class
