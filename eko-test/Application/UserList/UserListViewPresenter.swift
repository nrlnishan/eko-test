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
    
    // Fetching list item when list not empty i.e pagination
    case partialLoading
    
    // Error while fetching list item
    case error
    
    // After items are successfully fetched
    case available
}


protocol UserListViewPresenterDelegate: class {
    
    func setupViewState(state: UserListViewState)
}

class UserListViewPresenter {
    
    weak var delegate: UserListViewPresenterDelegate?
    
    
    
}
