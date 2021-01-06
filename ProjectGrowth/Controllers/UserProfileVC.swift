//
//  UserProfileVC.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 10/29/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
import Firebase

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        fetchUser()
        
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLogoutButton()
        
        fetchOrderedGrowths()
    }
    
    
    fileprivate func fetchOrderedGrowths() {
//        guard let uid = Firebase.Auth.auth().currentUser?.uid else {return}
        guard let uid = self.user?.uid else { return }
        let ref = Firebase.Database.database().reference().child("growths").child(uid)
    
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            print("fetchorderedgrowths: ", snapshot)
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            
            let growth = Growth(user: user, dictionary: dictionary)
            self.growths.insert(growth, at: 0)
            self.collectionView.reloadData()
        }, withCancel: { (err) in
            print("Failed to fetch ordered posts:", err)
  
    })
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
                print(growth.imageUrl)
                self.growths.append(growth)
            }
            self.collectionView.reloadData()
        } withCancel: { (err) in
            print("Failed to fetch growth posts", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return growths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
        
        cell.growth = growths[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-1)/2
        return CGSize(width: width, height: width)
    }
    
    fileprivate func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        print("logging out")
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
        
            do {
                try Auth.auth().signOut()
                
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
        
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(GrowthVC(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
    
    var user: User?
    func fetchUser() {
        
        let uid = userId ?? (Firebase.Auth.auth().currentUser?.uid ?? "")
//        guard let uid  = Firebase.Auth.auth().currentUser?.uid else { return }
        
        Firebase.Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            
            self.collectionView.reloadData()
            
            self.fetchOrderedGrowths()
        }
    }
}
