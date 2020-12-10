////
////  UpdateGrowthVC.swift
////  ProjectGrowth
////
////  Created by MattHew Phraxayavong on 12/2/20.
////  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class UpdateGrowthVC{
//    
//fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
//    guard let postImage = selectedImage else { return }
//    guard let caption = captionTextView.text else { return }
//    guard let titleText = titleLabelTextView.text else { return }
//    
//    guard let uid = Auth.auth().currentUser?.uid else { return }
//    
//    let userPostRef = Database.database().reference().child("growths").child(uid)
//    let ref = userPostRef.childByAutoId()
//    
//    let values = ["imageUrl": imageUrl, "title": titleText, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
//    
//    ref.updateChildValues(values) { (err, ref) in
//        if let err = err {
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//            print("Failed to save post to DB", err)
//            return
//        }
//        
//        print("Successfully saved post to DB")
//        self.dismiss(animated: true, completion: nil)
//        
////            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
//    }
//}
//}
