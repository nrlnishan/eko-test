//
//  AppError.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/4/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import Foundation

protocol AppError: Error {
    
}

enum ApiError: AppError {
    
    case malformedUrl
    case unknown
    case serialization
    case custom(message: String)
}

enum UserFetchError: AppError {
    
    case paginationUnavailable
}
