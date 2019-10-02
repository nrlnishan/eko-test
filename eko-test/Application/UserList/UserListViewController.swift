//
//  UserListViewController.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/1/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    let tableView = UITableView()
    let moreIndicator = UIActivityIndicatorView(style: .gray)
    
    override func loadView() {
        
        let newView = UIView()
        newView.backgroundColor = .white
        
        view = newView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setupForAutolayout(in: view)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UserListItemCell.self, forCellReuseIdentifier: UserListItemCell.identifier)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.reloadData()
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListItemCell.identifier) as? UserListItemCell else {
            
            print("Returning Default")
            return UITableViewCell()
            
        }
        
        print("Returning Cell")
        
        return cell
    }
}

