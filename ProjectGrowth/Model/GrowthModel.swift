//
//  GrowthModel.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 11/10/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit

struct Growth {
    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date
    
    init(user: User,dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
