//
//  MainTabBarVC.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 10/29/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let userprofileVC = UserProfileVC(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userprofileVC)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "home_selected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected")
        
        tabBar.tintColor = .black
        
        
        viewControllers = [navController, UIViewController()]
            
    }
    
    
    
}
