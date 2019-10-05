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
    
    func displayUserGithubDetail(githubUrl: String?)
}

class UserListViewPresenter {
    
    weak var delegate: UserListViewPresenterDelegate?
    
    var userService: GithubUserRepository
    var favouriteService: FavouriteUserRepository
    
    var state = UserListViewState.empty
    var userList = [GithubUser]()
    
    init(userRepository: GithubUserRepository, favouriteRepository: FavouriteUserRepository) {
        self.userService = userRepository
        self.favouriteService = favouriteRepository
        self.setupUserFetchingCompletionHandler()
    }
    
    func fetchListOfGithubUsers() {
        
        // Update State
        self.state = .loading
        self.delegate?.updateViewState(state: self.state)
        
        // Fetch Users
        self.userService.fetchListOfUsers(shouldPaginate: false)
    }
    
    func prefetchListOfGithubUsers() {
        
        // Check before fetching next page
        guard isPrefetchingAvailable() else { return }
        
        Log.add(info: "Prefetching next page...")
        
        // Update State
        self.state = .pagination
        self.delegate?.updateViewState(state: state)
        
        // Fetch Users
        self.userService.fetchListOfUsers(shouldPaginate: true)
    }
    
    func setupUserFetchingCompletionHandler() {
        
        self.userService.completionHandler = { [weak self] users, error in
            
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
            self.state = .available
            self.delegate?.updateViewState(state: state)
            
        default:
            self.state = .error(message: defaultErrMessage)
            self.delegate?.updateViewState(state: state)
        }
    }
    
    func handleUserFetchSuccess(users: [GithubUser]) {
        
        // Update user list
        userList.append(contentsOf: users)
        
        // Update State
        if userList.isEmpty {
            self.state = .empty
            self.delegate?.updateViewState(state: state)
        } else {
            self.state = .available
            self.delegate?.updateViewState(state: state)
        }
    }
    
    func getUserInformation(at indexPath: IndexPath) -> UserListItemCellModel {
        
        let userInfo = userList[indexPath.row]
        
        let isFavourite = favouriteService.getFavouriteStatus(user: userInfo)
        
        var viewModel = UserListItemCellModel(model: userInfo)
        viewModel.isFavourite = isFavourite
        
        return viewModel
    }
    
    func toggleUserFavouriteStatus(currentStatus: Bool, indexPath: IndexPath) {
        
        let user = userList[indexPath.row]
        let favStatus = !currentStatus
        
        self.favouriteService.setFavouriteStatus(user: user, status: favStatus)
        self.delegate?.updateFavouriteStatus(at: indexPath)
    }
    
    func displayGithubProfileOfUser(at indexPath: IndexPath) {
        
        let userInfo = userList[indexPath.row]
        let githubUrl = userInfo.htmlUrl
        
        self.delegate?.displayUserGithubDetail(githubUrl: githubUrl)
    }
    
    func isPrefetchingAvailable() -> Bool {
        
        switch state {
            
        case .available where userService.isPaginationAvailable:
            return true
        default:
            return false
        }
    }
}
