//
//  NewGrowthVC.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 11/9/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
import Firebase

class NewGrowthVC: UIViewController {
    
    var selectedImage: UIImage?  {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Grow", style: .plain, target: self, action: #selector(handleGrowth))
        setupView()
        
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .purple
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabelTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "Title"
        return label
    }()
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "Caption"
        return label
    }()
    
    fileprivate func setupView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 200)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 200, height: 200)
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        containerView.addSubview(titleLabelTextView)
        titleLabelTextView.anchor(top: titleLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
        
        containerView.addSubview(captionLabel)
        captionLabel.anchor(top: titleLabelTextView.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerView.addSubview(captionTextView)
        captionTextView.anchor(top: captionLabel.bottomAnchor, left: titleLabelTextView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
    }
    
    @objc fileprivate func handleGrowth() {
        guard let image = selectedImage else { return }
    
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let filename = NSUUID().uuidString
        let storageRef = Firebase.Storage.storage().reference().child("growths").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Failed to upload new image", err)
                return
            }
            storageRef.downloadURL { (downloadUrl, err) in
                if let err = err {
                    print("Failed to retrieve downloadUrl", err)
                    return
                }
                guard let imageUrl = downloadUrl?.absoluteString else { return }
                
                print("successfully uploaded image:", imageUrl)
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            }
        }
        
    
    }

    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let titleText = titleLabelTextView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("growths").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "title": titleText, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
            
//            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
        }
    }
}
