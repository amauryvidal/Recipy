//
//  DetailViewController.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import UIKit

enum Sections: Int {
    case image = 0
    case ingredients = 1
    case details = 2
}

class DetailViewController: UITableViewController {
    
    var imageDownloadTask: URLSessionDataTask?
    var image: UIImage?
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
            imageDownloadTask = RecipeAPI().downloadImage(at: recipe.imageUrl, completion: { (image) in
                self.imageDownloadTask = nil
                self.image = image
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: Sections.image.rawValue)], with: .automatic)
                }
            })
            
            // retreive the ingredients
            fetchRecipeDetails()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // If there is an image downloading, we cancel it
        imageDownloadTask?.cancel()
    }
    
    
    // MARK: - UITableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return recipe != nil ? 3 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
        case .image:
            return 1
        case .ingredients:
            return recipe?.ingredients?.count ?? 0
        case .details:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecipeImageCell.identifier, for: indexPath) as! RecipeImageCell
            cell.configure(image: image)
            return cell
        case .ingredients:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCellIdentifier", for: indexPath)
            cell.textLabel?.text = recipe?.ingredients?[indexPath.row]
            return cell
        case .details:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailCell.identifier, for: indexPath) as! RecipeDetailCell
            if let recipe = recipe {
                cell.configure(recipe: recipe)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Sections(rawValue: section) else {
            return nil
        }
        
        switch section {
        case .image:
            return nil
        case .ingredients:
            return "INGREDIENTS"
        case .details:
            return "INFO"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Sections(rawValue: indexPath.section) else {
            return 0
        }
        
        switch section {
        case .image:
            return 230
        case .ingredients:
            return 44
        case .details:
            return 88
        }
    }
    
    
    // MARK: - Network
    
    // Fetch additionals detail about the recipe
    func fetchRecipeDetails() {
        if let recipe = recipe {
            RecipeAPI().recipe(id: recipe.recipeId) { (recipeDetails) in
                if let recipeDetails = recipeDetails {
                    self.recipe = recipeDetails
                    
                    // Upate the view with the retrieved details
                    DispatchQueue.main.async {
                        self.updateDetails()
                    }
                }
            }
        }
    }
    
    func updateDetails() {
        
    }
}
