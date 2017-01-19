//
//  RecipeDetailCell.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailCell: UITableViewCell {
    static let identifier = "RecipeDetailCellIdentifier"
    
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var originalButton: UIButton!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    func configure(recipe: Recipe) {
        publisherLabel.text = recipe.publisher
        rankLabel.text = "Social rank: \(round(recipe.socialRank))"
    }
}
