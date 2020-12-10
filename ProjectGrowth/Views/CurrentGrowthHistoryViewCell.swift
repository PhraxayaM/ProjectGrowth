//
//  CurrentGrowthHistoryViewCell.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 11/23/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
class CurrentGrowthHistoryViewCell: UICollectionViewCell {
    
    var growthPosts: Growth? {
        didSet {
            guard let growthPostImageUrl = growthPosts?.imageUrl else { return }
            
            photoImageView.loadImage(urlString: growthPostImageUrl)
            
            guard let profileImageUrl = growthPosts?.user.profileImageUrl else { return }
            
            
//            captionLabel.text = growthPosts?.caption
        }
    }
    
    let photoImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
