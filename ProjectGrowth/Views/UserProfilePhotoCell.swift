//
//  UserProfilePhotoCell.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 11/10/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    var growth: Growth? {
        didSet {
            guard let imageUrl = growth?.imageUrl else { return }

            photoImageView.loadImage(urlString: imageUrl)
     
        }
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
