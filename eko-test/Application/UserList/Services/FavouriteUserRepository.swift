//
//  FavouriteUserRepository.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/5/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import Foundation

protocol FavouriteUserRepository {
    
    func setFavouriteStatus(user: GithubUser, status: Bool)
    func getFavouriteStatus(user: GithubUser) -> Bool
}

class FavouriteUserService: FavouriteUserRepository {
    
    var storageKey = "favourite_user_list"
    var storage: UserDefaults
    
    init() {
        storage = UserDefaults.standard
    }
    
    func setFavouriteStatus(user: GithubUser, status: Bool) {
        
        guard let id = user.id else { return }
        
        var favDict = storage.dictionary(forKey: storageKey) ?? [:]
        favDict["\(id)"] = status
        
        storage.set(favDict, forKey: storageKey)
        storage.synchronize()
    }
    
    func getFavouriteStatus(user: GithubUser) -> Bool {
        
        guard let id = user.id else { return false }
        
        let savedDict = storage.dictionary(forKey: storageKey) ?? [:]
        let isFavourite = savedDict["\(id)"] as? Bool ?? false
        
        return isFavourite
    }
}
