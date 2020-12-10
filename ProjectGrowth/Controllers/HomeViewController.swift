//
//  HomeViewController.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 6/7/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
    let cellId = "cellId"
    override func viewDidLoad() {
        collectionView.backgroundColor = .white
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
        fetchGrowths()
        fetchFollowingUserIds()
        

    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
        Firebase.Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value)
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach { (key, value) in
                Firebase.Database.fetchUserWithUID(uid: key) { (user) in
                    self.fetchGrowthsWithUser(user: user)
                }
            }
            
        } withCancel: { (err) in
            print("failed to fetch following user ids: ", err)
        }
    }
    
    func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo-1"))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        height += 80
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return growths.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeViewCell
        
        cell.growthPosts = growths[indexPath.item]
        
        return cell
    }
    
    var growths = [Growth]()
    fileprivate func fetchGrowths() {
        guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
        Firebase.Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchGrowthsWithUser(user: user)
        }

    }
    
    fileprivate func fetchGrowthsWithUser(user: User) {
  
        let ref = Firebase.Database.database().reference().child("growths").child(user.uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
                            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else {return}
                let growth = Growth(user: user, dictionary: dictionary)
                self.growths.append(growth)
            }
            self.growths.sort { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate)  == .orderedDescending
            }
            
            self.collectionView.reloadData()
        } withCancel: { (err) in
            print("Failed to fetch growth posts", err)
        }
    }
}
