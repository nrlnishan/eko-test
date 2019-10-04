//
//  Log.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/5/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import Foundation

// Class to print simple log on console
class Log {
    
    static var isEnabled = true
    
    class func add(info: Any?, method:String = #function) {
        if isEnabled {
            print("Log: [\(method)] \(String(describing: info))")
        }
    }
}
