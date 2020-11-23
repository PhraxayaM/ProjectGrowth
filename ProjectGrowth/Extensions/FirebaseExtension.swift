//
//  FirebaseExtension.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 11/21/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

extension FirebaseDatabase.Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
                Firebase.Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    guard let userDictionary = snapshot.value as? [String: Any] else { return }
        
                    let user = User(uid: uid, dictionary: userDictionary)
                    completion(user)
                } withCancel: { (err) in
                    print("Failed to fetch user for growth posts:", err)
                }
    }
}
