//
//  UserListViewPresenter.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/2/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import Foundation

enum UserListViewState {
    
    // When list is empty
    case empty
    
    // Fetching list items when list is empty
    case loading
    
    // Fetching list item when list not empty
    case pagination
    
    // Error while fetching list item
    case error(message: String)
    
    // After items are successfully fetched
    case available
}

protocol UserListViewPresenterDelegate: class {
    
    func updateViewState(state: UserListViewState)
    func updateFavouriteStatus(at indexPath: IndexPath)
}

class UserListViewPresenter {
    
    let defaultErrMessage = "We encountered an error while fetching Users. Try again later"
    
    weak var delegate: UserListViewPresenterDelegate?
    var userListService: UserFetchService
    
    var state = UserListViewState.loading
    var userList = [GithubUserViewModel]()
    
    init(service: UserFetchService) {
        self.userListService = service
    }
    
    func fetchListOfGithubUsers() {
        
        self.state = .loading
        self.delegate?.updateViewState(state: self.state)
        
        self.userListService.fetchListOfUsers(shouldPaginate: false)
    }
    
    func prefetchListOfGithubUsers() {
        
        guard isPrefetchingAvailable() else { return }
        
        // Update state to partial loading
        self.state = .pagination
        self.delegate?.updateViewState(state: state)
        
        // Actual fetching of users
        self.userListService.fetchListOfUsers(shouldPaginate: true)
    }
    
    func toggleUserFavouriteStatus(at indexPath: IndexPath) {
        
        self.delegate?.updateFavouriteStatus(at: indexPath)
    }
    
    private func isPrefetchingAvailable() -> Bool {
        
        switch state {
            
        case .available:
            return true
        default:
            return false
        }
    }
}
