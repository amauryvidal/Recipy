//
//  ApiManager.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation

enum RequestType {
    case search
    case get
}

typealias JSON = [String: Any]

struct RecipeAPI {
    private let apiKey = "0714e27e76464dc4c5135f36e726e364"
    private let urlComponents = URLComponents(string: "http://food2fork.com/api/")! // base URL components of the web service
    
    
    /// Build the api url with the given parameters
    ///
    /// - Parameters:
    ///   - type: The type of request (Search or Get)
    ///   - params: Customs parameters to send
    /// - Returns: The GET url
    private func buildURL(type: RequestType, params: [String: String?]?) -> URL {
        var queryItems = [URLQueryItem(name: "key", value: apiKey)]
        var components = urlComponents
        
        switch type {
        case .search:
            components.path += "search"
        case .get:
            components.path += "get"
        }
        
        if let params = params {
            for p in params {
                queryItems += [URLQueryItem(name: p.key, value: p.value)]
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    
    /// Build a search recipe api request
    ///
    /// - Parameters:
    ///   - query: The terms to search
    ///   - page: Page to load if there is more than 30 results
    /// - Returns: The GET url
    private func buildSearchRequest(query: String?, page: Int? = nil) -> URL {
        var params = ["q": query]
        if let page = page, page > 0 {
            params["page"] = String(page)
        }
        return buildURL(type: .search, params: ["q": query])
    }
    
    /// Build a get recipe api request
    ///
    /// - Parameters:
    ///   - recipeId: The id of the recipe as retreived in the search results
    /// - Returns: The GET url
    private func buildGetRequest(recipeId: String) -> URL {
        return buildURL(type: .get, params: ["rId": recipeId])
    }
    
    func recipe(matching query: String, completion: @escaping ([Recipe]) -> Void) {
        let url = buildSearchRequest(query: query)
        print(url)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            var recipes = [Recipe]()
            
            if let data = data,
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON {
                    debugPrint(jsonResult)
                    if let results = jsonResult?["recipes"] as? [JSON] {
                        for case let result in results {
                            if let recipe = Recipe(json: result) {
                                recipes += [recipe]
                            }
                        }
                    }
            }
            completion(recipes)
            
        }.resume()
    }
}
