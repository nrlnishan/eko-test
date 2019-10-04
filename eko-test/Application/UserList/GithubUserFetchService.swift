//
//  GithubUserFetchService.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/2/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import Foundation

protocol UserFetchService {
    
    func fetchListOfUsers(shouldPaginate: Bool)
    
    var isPaginationAvailable: Bool { get set }
    var paginationUrl: String? { get set }
    var completionHandler: (([GithubUser]?, AppError?)->())? { get set }
}

class GithubUserFetchService: UserFetchService {
    
    var paginationUrl: String?
    var isPaginationAvailable = false
    var completionHandler: (([GithubUser]?, AppError?)->())?
    
    func fetchListOfUsers(shouldPaginate: Bool) {
        
        // Determine Api Endpoint
        let apiEndpoint = shouldPaginate ? paginationUrl : "https://api.github.com/users"
        
        guard let urlEndpoint = apiEndpoint, let url = URL(string: urlEndpoint) else {
            
            self.handleApiResponse(users: nil, error: UserFetchError.paginationUnavailable)
            return
        }
        
        // Initiate request to server
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                self.handleApiResponse(users: nil, error: ApiError.custom(message: err.localizedDescription))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let responseData = data else {
                self.handleApiResponse(users: nil, error: ApiError.unknown)
                return
            }
            
            // Json Serialization of data
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
        
            guard let users = try? decoder.decode([GithubUser].self, from: responseData) else {
                self.handleApiResponse(users: nil, error: ApiError.serialization)
                return
            }
            
            // Handle pagination link
            let linkHeader = httpResponse.allHeaderFields["Link"] as? String ?? ""
            self.processPaginationLink(linkHeader: linkHeader)
            
            // Handle success response
            self.handleApiResponse(users: users, error: nil)
            
        }.resume()
    }
    
    // Helper method to execute completion handler in Main queue
    func handleApiResponse(users: [GithubUser]?, error: AppError?) {
        DispatchQueue.main.async {
            self.completionHandler?(users, error)
        }
    }
    
    /// Extracts the url for next page from the Link HTTP Header
    ///
    /// Link header string example: <https://api.github.com/users?since=46>; rel="next", <https://api.github.com/users{?since}>; rel="first"
    func processPaginationLink(linkHeader: String) {
        
        let links = linkHeader.components(separatedBy: ",")
        
        for link in links {
            
            let linkComp = link.components(separatedBy: ";")
            let lastComponent = linkComp[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let firstComponent = linkComp[0].trimmingCharacters(in: .whitespacesAndNewlines)
            
            let paginationKey = #"rel="next""#
            
            if lastComponent == paginationKey {
                self.paginationUrl = firstComponent.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
                self.isPaginationAvailable = true
                break
            }
        }
        
        // If url for next pagination is not found
        self.paginationUrl = nil
        self.isPaginationAvailable = false
    }
}


