//
//  PetTableViewCell.swift
//  Family Pet
//
//  Created by Ricardo Canales on 8/7/15.
//  Copyright (c) 2015 canalesb. All rights reserved.
//

import UIKit

class PetTableViewCell: PFTableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var petProfile: PFImageView!
    @IBOutlet weak var petDescription: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
}
