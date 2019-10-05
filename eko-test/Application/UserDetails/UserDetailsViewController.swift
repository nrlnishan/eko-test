//
//  UserDetailsViewController.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/2/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import UIKit
import WebKit

class UserDetailsViewController: UIViewController, WKNavigationDelegate {

    var webView = WKWebView()
    var githubUrl: String?
    var loadingIndicatorView = UIActivityIndicatorView(style: .gray)
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        loadGithubUrl()
    }
    
    func setupViews() {
        
        webView.setupForAutolayout(in: view)
        webView.alignHorizontalEdges(to: view)
        webView.alignTopToTop(of: view, constant: 0)
        webView.alignBottomToBottom(of: view, constant: 0)
        webView.navigationDelegate = self
        
        let loadingIndicatorItem = UIBarButtonItem(customView: loadingIndicatorView)
        navigationItem.rightBarButtonItem = loadingIndicatorItem
    }
    
    func loadGithubUrl() {
        
        let websiteUrl = githubUrl ?? ""
        
        guard let url = URL(string: websiteUrl) else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        loadingIndicatorView.startAnimating()
    }
    
    // MARK:- Webview delegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicatorView.stopAnimating()
    }
}
