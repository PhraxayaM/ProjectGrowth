//
//  UserProfileHeaderCell.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 10/29/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            
            profileIV.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username
            setupEditFollowButton()
            
        }
    }
    
    fileprivate func  setupEditFollowButton() {
        guard let currentLoggedInUserId = Firebase.Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            //edit profile
        } else {
            
            //check  if following
            
            Firebase.Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot.value)
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editFollowProfileButton.setTitle("Unfollow", for: .normal) } else {
                        
                        self.setupFollowStyle()
                }
                
            } withCancel: { (err) in
                    print("Failed to check if following: ", err)
                
            }

            
        }
    }
    
    @objc func handleEditOrFollow() {
        
        guard let currentLoggedInUserId = Firebase.Auth.auth().currentUser?.uid else {return}
        
        guard  let userId = user?.uid else { return }
        
        //unfollow
        
        if editFollowProfileButton.titleLabel?.text == "Unfollow" {
            Firebase.Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user:", err)
                    return
                }
                print("Successfully unfollowed user: ", self.user?.username ?? "")
                
                self.setupFollowStyle()
                
            }
        } else {
            //follow
            let ref = Firebase.Database.database().reference().child("following").child(currentLoggedInUserId)
            
            let values = [userId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to follow user", err)
                    return
                }
                
            }
            print("Successfully followed user: ", self.user?.username ?? "")
            
            self.editFollowProfileButton.setTitle("Unfollow", for: .normal)
            self.editFollowProfileButton.backgroundColor = .white
            self.editFollowProfileButton.setTitleColor(.black, for: .normal)
        }
        
    }
    
    fileprivate func setupFollowStyle() {
        self.editFollowProfileButton.setTitle("Follow", for: .normal)
        self.editFollowProfileButton.backgroundColor  = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editFollowProfileButton.setTitleColor(.white, for: .normal)
        self.editFollowProfileButton.layer.borderColor  = UIColor(white: 0, alpha: 0.2).cgColor
    }
    let profileIV: CustomImageView  = {
        let iv = CustomImageView()
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let growthsLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Growths", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
//        label.text = "11\nGrowths"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editFollowProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleEditOrFollow), for: .touchUpInside)
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileIV)
        profileIV.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileIV.layer.cornerRadius = 80/2
        profileIV.clipsToBounds = true
        
        setupBottomToolbar()
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileIV.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupUserStats()
        
        addSubview(editFollowProfileButton)
        editFollowProfileButton.anchor(top: growthsLabel.bottomAnchor, left: profileIV.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 30)

    }
    
    fileprivate func setupUserStats() {
        let stackView = UIStackView(arrangedSubviews: [growthsLabel, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileIV.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    
    }
    
    fileprivate func setupBottomToolbar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDiverView = UIView()
        bottomDiverView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [listButton, gridButton, bookmarkButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
    
        addSubview(stackView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        addSubview(topDividerView)
        addSubview(bottomDiverView)
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDiverView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
