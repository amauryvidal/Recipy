//
//  RecipeDetailViewModel.swift
//  Recipy
//
//  Created by Amaury Vidal on 25/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailViewModel {
    
    lazy var apiClient = RecipeAPI.shared
    
    private(set) var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var title: String {
        return recipe.title
    }
    
    func image(completion: @escaping (UIImage?) -> Void) {
        apiClient.downloadImage(at: recipe.imageUrl, completion: completion)
    }
    
    func cancelImageDownload() {
        apiClient.cancelImageDownload()
    }
    
    func details(completion: @escaping (Recipe?) -> Void) {
        apiClient.recipe(id: recipe.recipeId) { (recipeDetails) in
            if let recipeDetails = recipeDetails {
                self.recipe = recipeDetails
                completion(recipeDetails)
            }
        }
    }
    
    var nbIngredients: Int {
        return recipe.ingredients?.count ?? 0
    }
    
    func ingredient(at index: Int) -> String? {
        return recipe.ingredients?[index]
    }
}
