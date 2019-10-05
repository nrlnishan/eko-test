//
//  AppDelegate.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/1/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootController = setupInitialController()
        
        self.window?.rootViewController = rootController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func setupInitialController() -> UIViewController {
        
        let userListController = UserListViewController()
        
        let presenter = UserListViewPresenter(userRepository: GithubUserFetchService(), favouriteRepository: FavouriteUserService())
        presenter.delegate = userListController
        
        userListController.presenter = presenter
        
        let rootController = UINavigationController(rootViewController: userListController)
        
        return rootController
    }
}

