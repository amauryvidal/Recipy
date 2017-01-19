//
//  RecipeModelTests.swift
//  Recipy
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import XCTest
@testable import Recipy

class RecipeModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreationWithEmptyJsonIsNil() {
        let json: JSON = ["":""]
        let recipe = Recipe(json: json)
        XCTAssertNil(recipe)
    }
    
    func testCreationWithNotEnoughJsonFieldIsNil() {
        let json: JSON = ["image_url": "http://www.image.com/myimage.jpg"]
        let recipe = Recipe(json: json)
        XCTAssertNil(recipe)
    }
    
    func testCreationWithMinimumJsonFieldIsNotNil() {
        let json: JSON = ["publisher": "Allrecipes.com",
                          "social_rank": 99.81007979198002,
                          "f2f_url": "http://food2fork.com/F2F/recipes/view/29159",
                          "publisher_url": "http://allrecipes.com",
                          "title": "Slow-Cooker Chicken Tortilla Soup",
                          "source_url": "http://allrecipes.com/Recipe/Slow-Cooker-Chicken-Tortilla-Soup/Detail.aspx"]
        let recipe = Recipe(json: json)
        XCTAssertNotNil(recipe)
    }
    
    func testRecipeCreationDataMatchJson() {
        let json: JSON = ["publisher": "Allrecipes.com",
                          "social_rank": 99.81007979198002,
                          "f2f_url": "http://food2fork.com/F2F/recipes/view/29159",
                          "publisher_url": "http://allrecipes.com",
                          "title": "Slow-Cooker Chicken Tortilla Soup",
                          "source_url": "http://allrecipes.com/Recipe/Slow-Cooker-Chicken-Tortilla-Soup/Detail.aspx"]
        let recipe = Recipe(json: json)
        XCTAssertEqual(recipe?.publisher, "Allrecipes.com")
        XCTAssertEqual(recipe?.socialRank, 99.81007979198002)
        XCTAssertEqual(recipe?.f2fUrl.absoluteString, "http://food2fork.com/F2F/recipes/view/29159")
        XCTAssertEqual(recipe?.publisherUrl.absoluteString, "http://allrecipes.com")
        XCTAssertEqual(recipe?.title, "Slow-Cooker Chicken Tortilla Soup")
        XCTAssertEqual(recipe?.sourceUrl.absoluteString, "http://allrecipes.com/Recipe/Slow-Cooker-Chicken-Tortilla-Soup/Detail.aspx")
    }
    
    func testCreationWithNotIncorectJsonFieldFormatIsNil() {
        let json: JSON = ["publisher": "Allrecipes.com",
                          "social_rank": "99.81007979198002",
                          "f2f_url": "http://food2fork.com/F2F/recipes/view/29159",
                          "publisher_url": "http://allrecipes.com",
                          "title": "Slow-Cooker Chicken Tortilla Soup",
                          "source_url": "http://allrecipes.com/Recipe/Slow-Cooker-Chicken-Tortilla-Soup/Detail.aspx"]
        let recipe = Recipe(json: json)
        XCTAssertNil(recipe)
    }
}
