//
//  UserSearchCell.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 11/22/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileIV.loadImage(urlString: profileImageUrl)
        }
    }
    
    let profileIV: CustomImageView = {
       let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
        addSubview(profileIV)
        profileIV.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileIV.layer.cornerRadius = 50/2
        profileIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
 
        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, left: profileIV.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(seperatorView)
        
        seperatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
