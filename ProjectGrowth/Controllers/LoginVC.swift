//
//  LoginVC.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 10/26/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 243, green: 242, blue: 220)
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(signUpButton)
        view.addSubview(logoPhoto)
        
        signUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        logoPhoto.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        logoPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupView()
        
    }
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp() {
        let signUpVC = SignUpVC()
        print("signing up")

        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 35, green: 86, blue: 96), for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.rgb(red: 93, green: 139, blue: 125)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
        
    }()
    
    @objc func handleLogin() {
        guard let email = emailTF.text else { return }
        guard let password = passwordTF.text else { return }
    
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
            
                print("Failed to sign in with email:", err)
                return
            }
            print("Successfully logged back in with user:", user?.user.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarVC else { return }
//
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    
    }
    
    @objc func handleTextInputChange() {
        let isEmailValid = emailTF.text?.count ?? 0 > 0 && passwordTF.text?.count ?? 0 > 0
        
        if isEmailValid {
            loginButton.isEnabled  = true
            loginButton.backgroundColor = UIColor.rgb(red: 93, green: 139, blue: 125)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 149, blue: 149)
        }
    }
    let emailTF: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Email"
        tf.textAlignment = .center
        tf.backgroundColor = UIColor(white: 0, alpha: 0.05)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
        
    }()
    
    let passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.textAlignment = .center
        tf.backgroundColor = UIColor(white: 0, alpha: 0.05)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let logoPhoto: UIImageView = {
        let IV = UIImageView()
        IV.image = #imageLiteral(resourceName: "logopg2.png").withRenderingMode(.alwaysOriginal)
        IV.translatesAutoresizingMaskIntoConstraints = false
        return IV
    }()
    
    func setupView() {
        let stackView = UIStackView(arrangedSubviews: [emailTF, passwordTF, loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.anchor(top: logoPhoto.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 40, paddingRight: 40, width: 0, height: 200)
    }
}
