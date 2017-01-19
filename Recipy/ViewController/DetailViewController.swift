//
//  DetailViewController.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!

    var recipe: Recipe? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let recipe = recipe {
            navigationItem.title = recipe.title
            // update UI
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

