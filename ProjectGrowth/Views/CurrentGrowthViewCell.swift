//
//  CurrentGrowthViewCell.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 11/23/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit

class CurrentGrowthViewCell: UICollectionViewCell {
    
    var growthPosts: Growth? {
        didSet {
            guard let growthPostImageUrl = growthPosts?.imageUrl else { return }
            
            guard let growthImageUrl = growthPosts?.imageUrl else { return }
            
//            guard let growthCreationDate = growthPosts?.creationDate else { return }
            photoImageView.loadImage(urlString: growthImageUrl)
//            print("this is", growthCreationDate)
//            creationLabel.text = growthCreationDate
        }
    }
    
    let photoImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let creationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        addSubview(creationLabel)
        creationLabel.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
