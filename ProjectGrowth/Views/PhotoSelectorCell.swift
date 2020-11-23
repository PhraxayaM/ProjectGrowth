//
//  CustomCell.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 6/7/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {

    let photoIV: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .purple
        addSubview(photoIV)
        photoIV.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
