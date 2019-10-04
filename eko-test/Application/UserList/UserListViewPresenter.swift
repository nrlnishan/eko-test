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
    
    weak var delegate: UserListViewPresenterDelegate?
    var userListApiService: UserFetchService
    
    var state = UserListViewState.loading
    var userList = [GithubUser]()
    
    init(apiService: UserFetchService) {
        self.userListApiService = apiService
        self.setupUserFetchingCompletionHandler()
    }
    
    func fetchListOfGithubUsers() {
        
        // Update State
        self.state = .loading
        self.delegate?.updateViewState(state: self.state)
        
        // Fetch Users
        self.userListApiService.fetchListOfUsers(shouldPaginate: false)
    }
    
    func prefetchListOfGithubUsers() {
        
        // Check before fetching next page
        guard isPrefetchingAvailable() else { return }
        
        // Update State
        self.state = .pagination
        self.delegate?.updateViewState(state: state)
        
        // Fetch Users
        self.userListApiService.fetchListOfUsers(shouldPaginate: true)
    }
    
    func setupUserFetchingCompletionHandler() {
        
        self.userListApiService.completionHandler = { [weak self] users, error in
            
            DispatchQueue.main.async {
                
                if let err = error {
                    self?.handleUserFetchError(error: err)
                }
                
                if let userList = users {
                    self?.handleUserFetchSuccess(users: userList)
                }
            }
        }
    }
    
    func handleUserFetchError(error: AppError) {
        
        // If pagination is not available, just hide the loading indicator at the bottom
        // else just show error message alert.
        
        let defaultErrMessage = "We encountered an error while fetching Users. Try again later"
        
        switch error {
            
        case UserFetchError.paginationUnavailable:
            self.delegate?.updateViewState(state: .available)
            
        default:
            self.delegate?.updateViewState(state: .error(message: defaultErrMessage))
        }
    }
    
    func handleUserFetchSuccess(users: [GithubUser]) {
        
        // Update user list
        userList.append(contentsOf: users)
        
        // Update State
        if userList.isEmpty {
            self.delegate?.updateViewState(state: .empty)
        } else {
            self.delegate?.updateViewState(state: .available)
        }
    }
    
    func getUserInformation(at indexPath: IndexPath) -> UserListItemCellModel {
        
        let userInfo = userList[indexPath.row]
        
        let viewModel = UserListItemCellModel(model: userInfo)
        return viewModel
    }
    
    func isPrefetchingAvailable() -> Bool {
        
        switch state {
            
        case .available where userListApiService.isPaginationAvailable:
            return true
        default:
            return false
        }
    }
    
    func toggleUserFavouriteStatus(at indexPath: IndexPath) {
        
        self.delegate?.updateFavouriteStatus(at: indexPath)
    }
    
}
