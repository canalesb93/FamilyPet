//
//  FeedTableViewCell.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/12/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var typeIcon: UIImageView!
    @IBOutlet var date: UILabel!
    @IBOutlet var statusIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
