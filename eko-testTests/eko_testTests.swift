//
//  eko_testTests.swift
//  eko-testTests
//
//  Created by Nishan Niraula on 10/5/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import XCTest

@testable import eko_test

class eko_testTests: XCTestCase {
    
    var favouriteService: FavouriteUserRepository?

    override func setUp() {
        
        favouriteService = FavouriteUserService()
    }

    override func tearDown() {
        
        favouriteService = nil
    }
    
    
    func testLinkHeaderPaginationParsing() {
        
        // Given
        let fetchService = GithubUserFetchService()
        let linkHeaderExample = #"<https://api.github.com/users?since=46>; rel="next", <https://api.github.com/users{?since}>; rel="first""#
        
        // When
        fetchService.processPaginationLink(linkHeader: linkHeaderExample)
        
        // Then
        XCTAssertTrue(fetchService.isPaginationAvailable)
        XCTAssertEqual(fetchService.paginationUrl, "https://api.github.com/users?since=46")
    }
    
    func testFavouriteStatusStorage() {
        
        var testUser1 = GithubUser()
        testUser1.id = 16
        
        var testUser2 = GithubUser()
        testUser2.id = 300
        
        // When
        favouriteService?.setFavouriteStatus(user: testUser1, status: true)
        favouriteService?.setFavouriteStatus(user: testUser2, status: true)
        
        // Then
        let user1Status = favouriteService?.getFavouriteStatus(user: testUser1)
        let user2Status = favouriteService?.getFavouriteStatus(user: testUser2)
        
        XCTAssertTrue(user1Status!)
        XCTAssertTrue(user2Status!)
    }
    
    func testFavouriteStatusRemoval() {
        
        // Given
        var testUser1 = GithubUser()
        testUser1.id = 16
        
        var testUser2 = GithubUser()
        testUser2.id = 300
        
        // When
        favouriteService?.setFavouriteStatus(user: testUser1, status: false)
        favouriteService?.setFavouriteStatus(user: testUser2, status: false)
        
        // Then
        let user1Status = favouriteService?.getFavouriteStatus(user: testUser1)
        let user2Status = favouriteService?.getFavouriteStatus(user: testUser2)
        
        XCTAssertFalse(user1Status!)
        XCTAssertFalse(user2Status!)
    }
    
}
