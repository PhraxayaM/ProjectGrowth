//
//  LoginVC.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 10/26/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Logo").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let emailTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor  = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let usernameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor  = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor  = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 149, blue: 149)
        button.layer.cornerRadius =  5
        button.titleLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(photoButton)
        view.backgroundColor =  .white
        photoButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 70, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        setupInputFields()
        
        
    }
    fileprivate func setupInputFields() {
        
        let greenView = UIView()
        greenView.backgroundColor = .green
        let stackView  = UIStackView(arrangedSubviews: [emailTF, usernameTF, passwordTF, signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis  = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.anchor(top: photoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 40, paddingRight: 40, width: 0, height: 200)
            
    }
    
}
