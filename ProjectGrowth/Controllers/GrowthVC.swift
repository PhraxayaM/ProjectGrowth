//
//  GrowthVC.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 11/23/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
import Firebase

class GrowthVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .purple
        collectionView.register(CurrentGrowthViewCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchGrowths()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return growths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        height += 80
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CurrentGrowthViewCell
        cell.growthPosts = growths[indexPath.item]
        return cell
    }
    
    var growths = [Growth]()
    
    fileprivate func fetchGrowths() {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
        
        Firebase.Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
        } withCancel: { (err) in
            print("Failed to fetch user for Growth Posts", err)
        }

        let ref = Firebase.Database.database().reference().child("growths").child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else {return}
                
                
                let imageUrl = dictionary["imageUrl"] as? String
                let dummyUser = User(uid: uid, dictionary: ["username": "matttest"])
                
                let growth = Growth(user: dummyUser, dictionary: dictionary)

                self.growths.append(growth)
            }
            self.collectionView.reloadData()
        } withCancel: { (err) in
            print("Failed to fetch growth posts", err)
        }
    }
    
    
}
