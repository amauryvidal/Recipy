//
//  Recipe.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import Foundation

struct Recipe {
    let imageUrl: URL?
    let sourceUrl: URL
    let f2fUrl: URL
    let title: String
    let publisher: String
    let publisherUrl: URL
    let socialRank: Double
    let ingredients: [String]?
    let page: Int?
}

extension Recipe {
    init?(json: [String: Any]) {
        guard
            let sourceUrlRaw = json["source_url"] as? String,
            let f2fUrlRaw = json["f2f_url"] as? String,
            let title = json["title"] as? String,
            let publisher = json["publisher"] as? String,
            let publisherUrlRaw = json["publisher_url"] as? String,
            let socialRank = json["social_rank"] as? Double
            else {
                return nil
        }
        
        guard
            let sourceUrl = URL(string: sourceUrlRaw),
            let f2fUrl = URL(string: f2fUrlRaw),
            let publisherUrl = URL(string: publisherUrlRaw)
            else {
                return nil
        }
        
        let imageUrlRaw = json["image_url"] as? String
        self.imageUrl = imageUrlRaw != nil ? URL(string: imageUrlRaw!) : nil
        self.sourceUrl = sourceUrl
        self.f2fUrl = f2fUrl
        self.title = title
        self.publisher = publisher
        self.publisherUrl = publisherUrl
        self.socialRank = socialRank
        self.ingredients = json["ingredients"] as? [String]
        self.page = json["page"] as? Int
    }
}
