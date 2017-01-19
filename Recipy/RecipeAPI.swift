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
    
    internal func buildURL(type: RequestType, params: [String: String?]?) -> URL {
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
    
    private func buildSearchRequest(query: String?) -> URL {
        return buildURL(type: .search, params: ["q": query])
    }
    
    private func buildGetRequest(recipeId: String) -> URL {
        return buildURL(type: .get, params: ["rId": recipeId])
    }
    
    func recipe(matching query: String, completion: @escaping ([Recipe]) -> Void) {
        let url = buildSearchRequest(query: query)
        print(url)
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            var recipes = [Recipe]()
            
            if let data = data,
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON {
                    print(jsonResult)
                    if let results = jsonResult?["recipes"] as? [JSON] {
                        for case let result in results {
                            if let recipe = Recipe(json: result) {
                                recipes += [recipe]
                            }
                        }
                    }
            }
            
            completion(recipes)
        }).resume()
    }
}
