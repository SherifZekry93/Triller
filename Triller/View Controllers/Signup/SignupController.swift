//
//  SignupController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/18/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class SignupController: UIViewController {
    let backGroundImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "background")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let logoImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "logo-empty").withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        return image
    }()
    let scrollView: UIScrollView = {
        let scv = UIScrollView()
        scv.showsVerticalScrollIndicator = false
        scv.showsHorizontalScrollIndicator = false
        scv.bounces = false
        scv.contentInsetAdjustmentBehavior = .automatic
        return scv
    }()
    let userNameTextField:CustomTextField = {
        let userName = CustomTextField()
        userName.textIcon.image = #imageLiteral(resourceName: "love").withRenderingMode(.alwaysTemplate)
        userName.textIcon.tintColor = .white
        userName.customLabelPlaceHolder.text = "Username"
        return userName
    }()
    
    let passwordTextField:CustomTextField = {
        let password = CustomTextField()
        password.isSecureTextEntry = true
        password.customLabelPlaceHolder.text = "Password"
        return password
    }()
    
    let emailTextField:CustomTextField = {
        let email = CustomTextField()
        email.textIcon.image = #imageLiteral(resourceName: "love").withRenderingMode(.alwaysTemplate)
        email.textIcon.tintColor = .white
        email.customLabelPlaceHolder.text = "Username"
        return email
    }()
    

   
    
    let loginButton:UIButton = {
        let login = UIButton()
        login.backgroundColor = .white
        login.setTitle("Login", for: .normal)
        login.setTitleColor(.black, for: .normal)
        login.layer.cornerRadius = 20
        login.titleLabel?.font = UIFont.systemFont(ofSize: 19)
       // login.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return login
    }()
    
    let signUpButton:UIButton = {
        let signUp = UIButton()
        signUp.backgroundColor = .blue
        signUp.setTitle("Signup", for: .normal)
        signUp.setTitleColor(.white, for: .normal)
        signUp.layer.cornerRadius = 20
        signUp.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        //signUp.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return signUp
    }()

    lazy var controlsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userNameTextField,passwordTextField,loginButton,signUpButton])
        stack.axis = .vertical
        stack.spacing = 30
        return stack
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
    }
    var bottomAnchorConstraint:NSLayoutConstraint?
    
    func setupViews()
    {
        view.addSubview(backGroundImage)
        view.addSubview(logoImage)
        view.addSubview(scrollView)
        scrollView.addSubview(controlsStack)
        backGroundImage.anchorToView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        logoImage.anchorToView(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 150), centerH: true)
        scrollView.anchorToView(top: logoImage.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor,padding: .init(top: 0, left: 30, bottom: 0, right: 30),size: .init(width: 0, height:0))
        bottomAnchorConstraint =   scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant:0)
        bottomAnchorConstraint!.isActive = true
        //scrollView.backgroundColor = .red
        controlsStack.anchorToView(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, padding: .init(top: 30, left: 0, bottom:150, right: 0))
        controlsStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        userNameTextField.anchorToView(size: .init(width: 0, height: 35))
        passwordTextField.anchorToView(size: .init(width: 0, height: 35))
        emailTextField.anchorToView(size: .init(width: 0, height: 35))
        loginButton.anchorToView(size: .init(width: 0, height: 45))
        signUpButton.anchorToView(size:.init(width: 0, height: 45))
    }
}
