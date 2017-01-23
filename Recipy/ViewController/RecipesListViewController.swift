//
//  MasterViewController.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import UIKit

class RecipesListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var detailViewController: RecipeDetailViewController? = nil
    var loadingSpinner: UIActivityIndicatorView?
    var recipes = [Recipe]()
    var currentSearchPage = 1
    
    var loadingMore: Bool = false {
        didSet {
            if loadingMore == true {
                loadingSpinner?.startAnimating()
            } else {
                loadingSpinner?.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? RecipeDetailViewController
        }
        
        addLoadingIndicator()
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
    
    
    // MARK: - API
    
    func fetchRecipes(query: String) {
        // Display an indicator that we're fetching from network
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        RecipeAPI.shared.recipe(matching: query, page: currentSearchPage) { recipes in
            DispatchQueue.main.async {
                // Update the tableview from the main thread
                self.insertRecipes(recipes: recipes)
            }
            // Hide the indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.loadingMore = false
        }
    }
    
    func insertRecipes(recipes: [Recipe]) {
        if recipes.count > 0 {
            self.tableView.beginUpdates()
            self.recipes += recipes
            var indexPathsToInsert = [IndexPath]()
            let start = self.tableView.numberOfRows(inSection: 0)
            let end = start + recipes.count - 1
            for i in start...end {
                indexPathsToInsert += [IndexPath(row: i, section: 0)]
            }
            self.tableView.insertRows(at: indexPathsToInsert, with: .automatic)
            self.tableView.endUpdates()
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


// MARK: - Infinite Scroll
extension RecipesListViewController {
    
    /// Add a loading indicator when we are fetching more recipes
    func addLoadingIndicator() {
        if loadingSpinner == nil {
            loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            loadingSpinner?.color = UIColor(red: 22/255, green: 106.0/255, blue: 176/255, alpha: 1)
            loadingSpinner?.hidesWhenStopped = true
            tableView.tableFooterView = loadingSpinner
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        print("\(offsetY) > \(contentHeight - scrollView.frame.size.height)")
        if offsetY > contentHeight - scrollView.frame.size.height,
            loadingMore == false,
            recipes.count > 0,
            recipes.count % 30 == 0,
            let query = searchBar.text {
            
            loadingMore = true
            currentSearchPage += 1
            fetchRecipes(query: query)
        }
    }
}

// MARK: - Search Bar Delegate
extension RecipesListViewController: UISearchBarDelegate {
    // On return button launch the search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            
            // Clear previous results
            recipes.removeAll(keepingCapacity: false)
            tableView.reloadData()
            view.endEditing(true)
            currentSearchPage = 1
            
            fetchRecipes(query: query)
        }
    }
}

