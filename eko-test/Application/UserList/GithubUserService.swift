//
//  GithubUserService.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/2/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import Foundation

protocol UserFetchService {
    
    func fetchListOfUsers(paginationId: Int)
}
