//
//  MasterViewController.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import UIKit

class RecipesListViewController: UITableViewController {

    var detailViewController: RecipeDetailViewController? = nil
    var recipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? RecipeDetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let recipe = recipes[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! RecipeDetailViewController
                controller.recipe = recipe
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                view.endEditing(true)
            }
        }
    }
}


// MARK: - UITableView
extension RecipesListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCellIdentifier", for: indexPath)
        let recipe = recipes[indexPath.row]
        cell.textLabel?.text = recipe.title
        return cell
    }
}

// MARK: - Search Bar Delegate
extension RecipesListViewController: UISearchBarDelegate {
    // On return button launch the search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            
            // Display an indicator that we're fetching from network
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            // Clear previous results
            recipes.removeAll(keepingCapacity: false)
            tableView.reloadData()
            view.endEditing(true)
            
            RecipeAPI.shared.recipe(matching: query) { recipes in
                self.recipes = recipes
                DispatchQueue.main.async {
                    // Update the tableview from the main thread
                    self.tableView.reloadData()
                }
                // Hide the indicator
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}

