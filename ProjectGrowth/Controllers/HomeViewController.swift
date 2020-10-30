////
////  HomeViewController.swift
////  ProjectGrowth
////
////  Created by MattHew Phraxayavong on 6/7/20.
////  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
//class HomeViewController: UIViewController {
//   
//
//    fileprivate let collectionView:UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
//        return cv
//    }()
//    
//    override func viewDidLoad() {
//        view.backgroundColor = .white
//        
//        view.addSubview(collectionView)
//        
//        collectionView.backgroundColor = .white
//        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/2 + 50).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
////        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
//        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.5).isActive = true
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//}
