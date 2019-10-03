//
//  UserListItemCell.swift
//  eko-test
//
//  Created by Nishan Niraula on 10/2/19.
//  Copyright © 2019 nishan. All rights reserved.
//

import Foundation
import UIKit

enum UserListItemCellState {
    
    case favourite
    case notFavourite
}

class UserListItemCell: UITableViewCell {
    
    let avatarView = UIImageView()
    let userLoginLabel = UILabel()
    let githubUrlLabel = UILabel()
    let accountTypeLabel = UILabel()
    let siteAdminStatusLabel = UILabel()
    let favouriteButton = UIButton()
    
    var favouriteAction: (()->())?
    var favouriteState: UserListItemCellState = UserListItemCellState.notFavourite
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
        userLoginLabel.text = "The butterworth filter symphony"
        githubUrlLabel.text = "https://api.github.com/users/cheapRoc"
        accountTypeLabel.text = "Account: Organization"
        siteAdminStatusLabel.text = "Site Admin: True"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        avatarView.setupForAutolayout(in: contentView)
        avatarView.setSizeConstraint(height: 60, width: 60)
        avatarView.alignTopToTop(of: self.contentView, constant: 16)
        avatarView.alignLeadingToLeading(of: self.contentView, constant: 16)
        
        avatarView.contentMode = .scaleAspectFit
        avatarView.backgroundColor = UIColor.groupTableViewBackground
        
        // Login Label
        userLoginLabel.setupForAutolayout(in: contentView)
        userLoginLabel.alignLeadingToTrailing(of: avatarView, constant: 16)
        userLoginLabel.alignTopToTop(of: avatarView, constant: 0)
        
        // Favourite Button
        let favouriteImage = UIImage(named: "ic_favourite")?.withRenderingMode(.alwaysTemplate)
        favouriteButton.setupForAutolayout(in: contentView)
        favouriteButton.tintColor = UIColor.groupTableViewBackground
        favouriteButton.setImage(favouriteImage, for: .normal)
        favouriteButton.addTarget(self, action: #selector(onFavouriteButtonTap), for: .touchUpInside)
        favouriteButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        favouriteButton.setSizeConstraint(height: 40, width: 40)
        favouriteButton.alignTopToTop(of: avatarView, constant: -10)
        favouriteButton.alignTrailingToTrailing(of: contentView, constant: 16)
        favouriteButton.alignLeadingToTrailing(of: userLoginLabel, constant: 8)
        
        // Github URL Label
        githubUrlLabel.setupForAutolayout(in: contentView)
        githubUrlLabel.alignHorizontalEdges(to: userLoginLabel)
        githubUrlLabel.alignTopToBottom(of: userLoginLabel, constant: 8)
        
        // Account Type Label
        accountTypeLabel.setupForAutolayout(in: contentView)
        accountTypeLabel.alignHorizontalEdges(to: userLoginLabel)
        accountTypeLabel.alignTopToBottom(of: githubUrlLabel, constant: 8)
        
        // Site Admin Status Label
        siteAdminStatusLabel.setupForAutolayout(in: contentView)
        siteAdminStatusLabel.alignHorizontalEdges(to: userLoginLabel)
        siteAdminStatusLabel.alignTopToBottom(of: accountTypeLabel, constant: 8)
        
        siteAdminStatusLabel.alignTopToBottom(of: accountTypeLabel, constant: 8)
        siteAdminStatusLabel.alignBottomToBottom(of: contentView, constant: 16)
        
        configureLabel(label: userLoginLabel, textStyle: .headline, color: .darkText)
        configureLabel(label: githubUrlLabel, textStyle: .subheadline, color: .darkText)
        configureLabel(label: accountTypeLabel, textStyle: .subheadline, color: .darkGray)
        configureLabel(label: siteAdminStatusLabel, textStyle: .subheadline, color: .darkGray)
    }
    
    func updateFavouriteStatus(isFavourite: Bool) {
        favouriteButton.tintColor = isFavourite ? UIColor.darkGray : UIColor.groupTableViewBackground
    }
    
    // Button Action
    @objc func onFavouriteButtonTap() {
        
        print("Favourite Button Tap")
        
        favouriteAction?()
    }
    
    private func configureLabel(label: UILabel, textStyle: UIFont.TextStyle, color: UIColor) {
        label.font = UIFont.preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = color
        label.numberOfLines = 0
    }
}
