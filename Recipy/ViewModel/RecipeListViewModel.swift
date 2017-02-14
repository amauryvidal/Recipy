//
//  RecipeListViewModel.swift
//  Recipy
//
//  Created by Amaury Vidal on 25/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation

struct RecipesListViewModel {
    private let apiClient = RecipeAPI.shared
    private let recipes: [Recipe]
    private let currentSearchPage: Int
    
    init(recipes: [Recipe] = [Recipe](), page: Int = 1) {
        self.recipes = recipes
        self.currentSearchPage = page
    }
    
    func recipe(at index: Int) -> Recipe? {
        return recipes[index]
    }
    
    func recipes(matching query: String, completion: @escaping ([Recipe]) -> Void) {
        apiClient.recipe(matching: query, page: currentSearchPage, completion: completion)
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
    
    func added(recipes: [Recipe]) -> RecipesListViewModel {
        let recipesConcat = self.recipes + recipes
        print(recipesConcat.count)
        return RecipesListViewModel(recipes: recipesConcat, page: currentSearchPage)
    }
    
    func incrementedPage() -> RecipesListViewModel {
        return RecipesListViewModel(recipes: recipes, page: currentSearchPage + 1)
    }
    
    func reseted() -> RecipesListViewModel {
        return RecipesListViewModel()
    }
}
