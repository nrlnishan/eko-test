//
//  Extensions.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/2/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func setImage(url: String?) {
        
        guard let imageUrl = url, let downloadUrl = URL(string: imageUrl) else { return }
        
        self.sd_setImage(with: downloadUrl, completed: nil)
    }
}

extension UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK:- Autolayout Extensions
    //
    // Simple Extensions to ease autolayout based setup when using LayoutAnchor
    
    func setupForAutolayout(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
    }
    
    func setSizeConstraint(height: CGFloat, width: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func alignHorizontalEdges(to view: UIView) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // Top
    
    func alignTopToTop(of view: UIView, constant: CGFloat) {
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
    }
    
    func alignTopToBottom(of view: UIView, constant: CGFloat) {
        self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
    }
    
    // Leading
    
    func alignLeadingToLeading(of view: UIView, constant: CGFloat) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
    }
    
    func alignLeadingToTrailing(of view: UIView, constant: CGFloat) {
        self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
    }
    
    // Trailing

    func alignTrailingToTrailing(of view: UIView, constant: CGFloat) {
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
    }
    
    // Bottom
    
    func alignBottomToBottom(of view: UIView, constant: CGFloat) {
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).isActive = true
    }
    
    func alignBottomToTop(of view: UIView, constant: CGFloat) {
        self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -constant).isActive = true
    }
    
    // Center
    func alignCenterVertically(in view: UIView) {
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func alignCenterHorizontally(in view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}
