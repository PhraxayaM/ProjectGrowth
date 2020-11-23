//
//  MainTabBarVC.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 10/29/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorVC(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if Firebase.Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginVC()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        setupViewControllers()
    }
    
    func setupViewControllers() {
        //home
        let homeLayout = UICollectionViewFlowLayout()
        
//        let homeController = HomeViewController(collectionViewLayout: homeLayout)
        let homeNavController = templateNavController(unselectedImage:#imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeViewController(collectionViewLayout: homeLayout))

        
        //search
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_selected"), selectedImage: #imageLiteral(resourceName: "search_unselected"), rootViewController: UserSearchVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        //plus/create new
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        //user profile
        let layout = UICollectionViewFlowLayout()
        let userprofileVC = UserProfileVC(collectionViewLayout: layout)
        
        let userProfileNavController = UINavigationController(rootViewController: userprofileVC)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_unselected")
        
        tabBar.tintColor = .black
        
        
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController, userProfileNavController]
    
        //change tab bar insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
    
}
