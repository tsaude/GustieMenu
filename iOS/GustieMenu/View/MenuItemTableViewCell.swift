//
//  BookTableViewCell.swift
//  Book-Q
//
//  Created by Tucker Saude on 8/26/16.
//  Copyright © 2016 Tucker Saude. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!

    var menuItem: MenuItemViewModel? {
        didSet {
            nameLabel?.text = menuItem?.name
            priceLabel?.text = menuItem?.price
            typeLabel?.text = menuItem?.type
        }
    }
}
