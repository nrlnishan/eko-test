//
//  GithubUserService.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/2/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import Foundation

enum AppError: Error {
    
    case malformedUrl
    case apiError(message: String)
}

protocol UserFetchService {
    
    func fetchListOfUsers(paginationId: Int?, onSuccess: @escaping ([GithubUser], Int?)->(), onError: @escaping (AppError)->())
}

class GithubUserFetchService: UserFetchService {
    
    func fetchListOfUsers(paginationId: Int?, onSuccess: @escaping ([GithubUser], Int?) -> (), onError: @escaping (AppError) -> ()) {
        
        var apiEndpoint = "https://api.github.com/users?since="
        
        if let sinceValue = paginationId {
            apiEndpoint += "\(sinceValue)"
        }
        
        guard let url = URL(string: apiEndpoint) else {
            onError(AppError.malformedUrl)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                onError(AppError.apiError(message: err.localizedDescription))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let responseData = data else {
                onError(AppError.apiError(message: "We encountered an error while fetching Users. Try again later"))
                return
            }
            
            let linkHeader = httpResponse.allHeaderFields["Link"] as? String
            
            
            // Link Header Example
            // <https://api.github.com/users?since=46>; rel="next", <https://api.github.com/users{?since}>; rel="first"
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let users = try? decoder.decode([GithubUser].self, from: responseData)
            
        }.resume()
    }
    
}


