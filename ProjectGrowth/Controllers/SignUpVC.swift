//
//  SignUpVC.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 11/1/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            photoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
            photoButton.setImage(originalImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        photoButton.layer.cornerRadius = photoButton.frame.width/2
        photoButton.layer.masksToBounds = true
        photoButton.layer.borderWidth = 3
        photoButton.layer.borderColor = UIColor.black.cgColor
        
        dismiss(animated: true, completion: nil)
    }
    
    let emailTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor  = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handeTextInputChange), for: .editingChanged)
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return tf
    }()
    
    @objc func handeTextInputChange() {
        let isEmailValid = emailTF.text?.count ?? 0 > 0 && usernameTF.text?.count ?? 0 > 0 && passwordTF.text?.count ?? 0 > 0
        
        if isEmailValid {
            signUpButton.isEnabled  = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 149, blue: 149)
        }
        
    }
    
    let usernameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor  = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handeTextInputChange), for: .editingChanged)
        tf.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return tf
    }()
    
    let passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor  = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handeTextInputChange), for: .editingChanged)
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 149, blue: 149)
        button.layer.cornerRadius =  5
        button.titleLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignUp()  {
        guard let email = emailTF.text, email.count > 0 else { return }
        guard let username = usernameTF.text, username.count > 0 else { return }
        guard let password = passwordTF.text, password.count > 0 else { return }
        Firebase.Auth.auth().createUser(withEmail: email, password: password) { (user: AuthDataResult?, err: Error?) in
            if let err = err {
                print("Failed to create user:", err)
                return
            }
            
            print("User created:", user?.user.uid ?? "")
            
            guard let image = self.photoButton.imageView?.image else { return }
            
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
            
            // Firebase 5 Update: Must now retrieve downloadURL
            storageRef.downloadURL(completion: { (downloadURL, err) in
                guard let profileImageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded profile image:", profileImageUrl)
                
                guard let uid = user?.user.uid else { return }
                
                let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                let values = [uid: dictionaryValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if let err = err {
                        print("Failed to save user info into db:", err)
                        return
                    }
                    
                    print("Successfully saved user info to db")
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarVC else { return }
                    
                    mainTabBarController.setupViewControllers()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
            })
            })
            }
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    //already have account move to sign in page
    @objc func handleLogin() {
        navigationController?.popViewController(animated: true)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(photoButton)
        view.backgroundColor = UIColor.rgb(red: 243, green: 242, blue: 220)
        photoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        view.addSubview(loginButton)
        loginButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
    }
    fileprivate func setupInputFields() {
        
        let stackView  = UIStackView(arrangedSubviews: [emailTF, usernameTF, passwordTF, signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis  = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.anchor(top: photoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 40, paddingRight: 40, width: 0, height: 200)
            
    }
    
}
