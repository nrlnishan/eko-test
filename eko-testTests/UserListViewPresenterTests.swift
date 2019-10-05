//
//  UserListViewPresenterTests.swift
//  eko-testTests
//
//  Created by Nishan Niraula on 10/5/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import XCTest

@testable import eko_test

class UserListViewPresenterTests: XCTestCase {

    var delegate = MockUserListViewPresenterDelegate()
    var userRepo = MockGithubUserRepository()
    var favRepo = FavouriteUserService()
    var presenter: UserListViewPresenter?
    
    var userList = [GithubUser]()
    
    override func setUp() {
        
        presenter = UserListViewPresenter(userRepository: userRepo, favouriteRepository: favRepo)
        presenter?.delegate = delegate
        
        var user1 = GithubUser()
        user1.id = 10
        user1.htmlUrl = "http://github.com/10"
        
        var user2 = GithubUser()
        user2.id = 20
        user2.htmlUrl = "http://github.com/20"
        
        userList = [user1, user2]
    }

    func testUserFetchSuccessHandlerWhenUserIsAvailable() {
        
        // Given
        userRepo.isSuccessMock = true
        userRepo.userList = userList
        
        // Then
        let expectation = XCTestExpectation(description: "User should be fetched")
        expectation.expectedFulfillmentCount = 2
        
        delegate.onStateChange = { state in
            
            switch state {
            case .available, .loading:
                expectation.fulfill()
                
            default:
                break
            }
        }
        
        // When
        presenter?.fetchListOfGithubUsers()
        
        wait(for: [expectation], timeout: 2)
        
        let userListCount = self.presenter?.userList.count ?? 0
        XCTAssert(userListCount == 2)
    }

    func testUserFetchSuccessHandlerWhenUserIsEmpty() {
        
        // Given
        userRepo.isSuccessMock = true
        userRepo.userList = []
        
        // Then
        let expectation = XCTestExpectation(description: "User should be fetched")
        expectation.expectedFulfillmentCount = 2
        
        delegate.onStateChange = { state in
            
            switch state {
            case .empty, .loading:
                expectation.fulfill()
                
            default:
                break
            }
        }
        
        // When
        presenter?.fetchListOfGithubUsers()
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testUserPrefetchSuccessCondition() {
        
        presenter?.state = .available
        
        userRepo.isSuccessMock = true
        userRepo.userList = userList
        
        let exp = XCTestExpectation(description: "Users should be prefetched")
        exp.expectedFulfillmentCount = 2
        
        delegate.onStateChange = { state in
            
            switch state {
            case .pagination, .available:
                exp.fulfill()
            default:
                break
            }
        }
        
        presenter?.prefetchListOfGithubUsers()
        
        wait(for: [exp], timeout: 2)
    }
    
    func testCompletionHandlerSetup() {
        
        // If completion handler is set, then state would be changed
        // when completion handler is executed
        
        presenter?.setupUserFetchingCompletionHandler()
        
        let exp = XCTestExpectation(description: "State should be changed twice")
        exp.expectedFulfillmentCount = 2
        
        delegate.onStateChange = { state in
            exp.fulfill()
        }
        
        userRepo.completionHandler?(nil, ApiError.serialization)
        userRepo.completionHandler?(userList, nil)
        
        wait(for: [exp], timeout: 5)
    }
    
    func testSecondPrefetchingWhenFirstInProgress() {
        
        let exp = XCTestExpectation(description: "State change should not be called")
        exp.isInverted = true
        
        presenter?.state = .pagination
        delegate.onStateChange = { state in
            exp.fulfill()
        }
        
        presenter?.prefetchListOfGithubUsers()
        
        wait(for: [exp], timeout: 2)
    }
    
    func testPrefetchingAvailability() {
        
        presenter?.state = .loading
        
        let isAvailable1 = presenter?.isPrefetchingAvailable()
        XCTAssertFalse(isAvailable1!)
        
        presenter?.state = .available
        userRepo.isPaginationAvailable = false
        
        let isAvailable2 = presenter?.isPrefetchingAvailable()
        XCTAssertFalse(isAvailable2!)
        
        presenter?.state = .available
        userRepo.isPaginationAvailable = true
        
        let isAvailable3 = presenter?.isPrefetchingAvailable()
        XCTAssertTrue(isAvailable3!)
        
    }
    
    func testUserListItemSelection() {
        
        presenter?.userList = userList
        presenter?.displayGithubProfileOfUser(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(delegate.isDisplayUserGithubDetailCalled)
        XCTAssertNotNil(delegate.userGithubUrl)
        XCTAssertEqual("http://github.com/10", delegate.userGithubUrl!)
    }
    
    func testUserFavouriteToggleAction() {
        
        presenter?.userList = userList
        presenter?.toggleUserFavouriteStatus(currentStatus: true, indexPath: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(delegate.isUpdateFavouriteStatusCalled)
    }
}

// MARK:- Mocks

class MockGithubUserRepository: GithubUserRepository {
    
    var paginationUrl: String?
    var isPaginationAvailable: Bool = true
    var completionHandler: (([GithubUser]?, AppError?)->())?
    
    // Helper properties to mock this repository
    var isSuccessMock: Bool = true
    var userList: [GithubUser]?
    var error: AppError?
    
    func fetchListOfUsers(shouldPaginate: Bool) {
        
        // Simulating 1 second network request condition
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            if self.isSuccessMock {
                self.completionHandler?(self.userList, self.error)
            } else {
                self.completionHandler?(self.userList, self.error)
            }
        }
    }
}

class MockUserListViewPresenterDelegate: UserListViewPresenterDelegate {
    
    // Helper properties to mock this delegate
    var state: UserListViewState?
    
    var isUpdateFavouriteStatusCalled = false
    var userIndexPath: IndexPath?
    
    var isDisplayUserGithubDetailCalled = false
    var userGithubUrl: String?
    
    var onStateChange: ((UserListViewState)->())?
    
    func updateViewState(state: UserListViewState) {
        self.state = state
        self.onStateChange?(state)
    }
    
    func updateFavouriteStatus(at indexPath: IndexPath) {
        
        self.isUpdateFavouriteStatusCalled = true
        self.userIndexPath = indexPath
    }
    
    func displayUserGithubDetail(githubUrl: String?) {
        
        self.isDisplayUserGithubDetailCalled = true
        self.userGithubUrl = githubUrl
    }
}
