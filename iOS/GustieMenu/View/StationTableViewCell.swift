//
//  BookTableViewCell.swift
//  Book-Q
//
//  Created by Tucker Saude on 8/26/16.
//  Copyright © 2016 Tucker Saude. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var indicatorImageView: UIImageView!

    var station: StationViewModel? {
        didSet {
            if let station = station {
                nameLabel.text = station.name
                indicatorImageView.image = UIImage(named: station.isShowingMenuItems ? "indicator_up" : "indicator")
            } else {
                nameLabel?.text = ""
                indicatorImageView?.image = nil
            }
        }
    }
    

}
