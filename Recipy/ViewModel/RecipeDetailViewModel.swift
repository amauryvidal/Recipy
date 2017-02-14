//
//  RecipeDetailViewModel.swift
//  Recipy
//
//  Created by Amaury Vidal on 25/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation
import UIKit

struct RecipeDetailViewModel {
    private let apiClient = RecipeAPI.shared
    
    let recipe: Recipe
    
    var title: String {
        return recipe.title
    }
    
    func image(completion: @escaping (UIImage?) -> Void) {
        apiClient.downloadImage(at: recipe.imageUrl, completion: completion)
    }
    
    func cancelImageDownload() {
        apiClient.cancelImageDownload()
    }
    
    var nbIngredients: Int {
        return recipe.ingredients?.count ?? 0
    }
    
    func ingredient(at index: Int) -> String? {
        return recipe.ingredients?[index]
    }
    
    func details(completion: @escaping (RecipeDetailViewModel) -> Void) {
        apiClient.recipe(id: recipe.recipeId) { (recipeDetails) in
            if let recipeDetails = recipeDetails {
                let vm = RecipeDetailViewModel(recipe: recipeDetails)
                completion(vm)
            }
        }
    }
}
