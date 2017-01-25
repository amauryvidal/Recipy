//
//  RecipeListViewModel.swift
//  Recipy
//
//  Created by Amaury Vidal on 25/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation

class RecipesListViewModel {
    
    private lazy var apiClient = RecipeAPI.shared
    private var recipes = [Recipe]()
    private var currentSearchPage = 1
    
    func recipe(at index: Int) -> Recipe? {
        return recipes[index]
    }
    
    func recipes(matching query: String, completion: @escaping ([Recipe]) -> Void) {
        apiClient.recipe(matching: query, page: currentSearchPage, completion: completion)
    }
    
    func add(recipes: [Recipe]) {
        self.recipes += recipes
    }
    
    var nbRecipes: Int {
        return recipes.count
    }
    
    func title(at index: Int) -> String? {
        return recipe(at: index)?.title
    }
    
    var noMoreResults: Bool {
        return !(recipes.count > 0 && recipes.count % 30 == 0)
    }
    
    func incrementPage() {
        currentSearchPage += 1
    }
    
    func reset() {
        recipes.removeAll(keepingCapacity: false)
        currentSearchPage = 1
    }
}
