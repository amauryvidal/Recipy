//
//  RecipyTests.swift
//  RecipyTests
//
//  Created by Amaury Vidal on 19/01/2017.
//  Copyright © 2017 AmauryVidal. All rights reserved.
//

import XCTest
@testable import Recipy

class RecipyApiTests: XCTestCase {
    
    let recipeAPI = RecipeAPI()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMinimalApiSearchSuccess() {
        let url = recipeAPI.buildURL(type: .search, params: nil)

        let waitResult = expectation(description: "Wait for results")
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            waitResult.fulfill()
            
            guard error == nil, let response = response as? HTTPURLResponse else {
                XCTFail("Minimal API call failed")
                return
            }
            
            let httpStatusCode = response.statusCode
            XCTAssertEqual(httpStatusCode, 200, "Minimal API call failed")
        }).resume()
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    
    func testMinimalApiGetSuccess() {
        let url = recipeAPI.buildURL(type: .get, params: nil)
        
        let waitResult = expectation(description: "Wait for results")
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            waitResult.fulfill()
            
            guard error == nil, let response = response as? HTTPURLResponse else {
                XCTFail("Minimal API call failed")
                return
            }
            
            let httpStatusCode = response.statusCode
            XCTAssertEqual(httpStatusCode, 200, "Minimal API call failed")
        }).resume()
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
