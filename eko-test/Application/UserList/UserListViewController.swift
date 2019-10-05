//
//  UserListViewController.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/1/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UserListViewPresenterDelegate {

    let tableView = UITableView()
    
    let loadingIndicatorView = UIActivityIndicatorView(style: .gray)
    let messageLabel = UILabel()
    
    let prefetchIndicatorView = UIActivityIndicatorView(style: .gray)
    let prefetchThreshold: CGFloat = 300
    
    var presenter: UserListViewPresenter?
    
    override func loadView() {
        
        let newView = UIView()
        newView.backgroundColor = .white
        
        view = newView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        presenter?.fetchListOfGithubUsers()
    }
    
    func setupViews() {
        
        self.title = "Users"
        
        messageLabel.setupForAutolayout(in: view)
        messageLabel.alignCenterVertically(in: view)
        messageLabel.alignLeadingToLeading(of: view, constant: 16)
        messageLabel.alignTrailingToTrailing(of: view, constant: 16)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        messageLabel.textColor = UIColor.darkText
        
        loadingIndicatorView.setupForAutolayout(in: view)
        loadingIndicatorView.alignCenterHorizontally(in: view)
        loadingIndicatorView.alignBottomToTop(of: messageLabel, constant: 8)
        
        loadingIndicatorView.hidesWhenStopped = true
        prefetchIndicatorView.hidesWhenStopped = true
        
        tableView.setupForAutolayout(in: view)
        tableView.alignHorizontalEdges(to: view)
        tableView.alignTopToTop(of: view, constant: 0)
        tableView.alignBottomToBottom(of: view, constant: 0)
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = prefetchIndicatorView
        
        tableView.register(UserListItemCell.self, forCellReuseIdentifier: UserListItemCell.identifier)
    }
    
    func updateViewState(state: UserListViewState) {
        
        switch state {
        case .empty:
            
            // Hide tableView & display message
            messageLabel.isHidden = false
            messageLabel.text = "No User Found"
            
            tableView.isHidden = true
            
        case .available:
            
            // Hide any loading indicator or messages
            loadingIndicatorView.stopAnimating()
            prefetchIndicatorView.stopAnimating()
            messageLabel.isHidden = true
            
            // Refresh data
            tableView.isHidden = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
        
        case .error(let message):
            
            // Hide tableview & display error alert
            tableView.isHidden = true
            
            displayErrorAlert(message: message)
            
        case .loading:
            
            // Hide tableView & display network request indicators
            tableView.isHidden = true
            
            loadingIndicatorView.startAnimating()
            messageLabel.text = "Fetching Users..."
            
        case .pagination:
            
            // Just show loading indicator at the bottom
            prefetchIndicatorView.startAnimating()
        }
    }
    
    func updateFavouriteStatus(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func displayUserGithubDetail(githubUrl: String?) {
        
        let controller = UserDetailsViewController()
        controller.githubUrl = githubUrl
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK:- Private Helpers
    
    private func displayErrorAlert(message: String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK:- TableView DataSource & Delegates
extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.userList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListItemCell.identifier) as? UserListItemCell else { return UITableViewCell() }
        
        let viewModel = presenter?.getUserInformation(at: indexPath)
        cell.setupViewInformation(info: viewModel)
        
        cell.favouriteAction = { [weak self] isFavourite in
            self?.presenter?.toggleUserFavouriteStatus(currentStatus: isFavourite, indexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        presenter?.displayGithubProfileOfUser(at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentScrollDistance = scrollView.contentOffset.y
        let maxScrollableDistance = scrollView.contentSize.height - scrollView.frame.size.height
        
        let remainingScrollDistance = maxScrollableDistance - currentScrollDistance
        
        // Start prefetching if remaining distance is less than the threshold
        guard remainingScrollDistance <= prefetchThreshold else { return }
        
        presenter?.prefetchListOfGithubUsers()
    }
}


