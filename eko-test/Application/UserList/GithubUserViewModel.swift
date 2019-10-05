//
//  UserListItemCellModel.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/4/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import Foundation

struct UserListItemCellModel {
    
    var loginLabelDesc: String
    var avatarUrl: String
    var githubUrl: String
    var accountTypeDesc: String
    var siteAdminStatus: String
    
    var isFavourite: Bool = false
    
    init(model: GithubUser) {
        
        loginLabelDesc = model.login ?? "-"
        avatarUrl = model.avatarUrl ?? ""
        githubUrl = model.htmlUrl ?? "Github Not Available"
        
        let accountType = model.type ?? "-"
        accountTypeDesc = "Account: " + accountType
        
        let adminStatus = model.siteAdmin?.description ?? "-"
        siteAdminStatus = "Site Admin: " + adminStatus
    }
}
