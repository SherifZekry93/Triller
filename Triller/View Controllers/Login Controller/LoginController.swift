//
//  LoginController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/18/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
class LoginController: UIViewController
{
    var bottomAnchorConstraint:NSLayoutConstraint?
    let backGroundImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "background")
        image.contentMode = .scaleAspectFill//Fit
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
    let forgotPasswordLabel:UILabel = {
        let label = UILabel()
        label.text = "Forgot Password?"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    let languageLabel:UILabel = {
       let label = UILabel()
        label.text = "العربية"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let userNameTextField:CustomTextField = {
        let userName = CustomTextField()
        userName.textIcon.image = #imageLiteral(resourceName: "love").withRenderingMode(.alwaysTemplate)
        userName.textIcon.tintColor = .white
        userName.customLabelPlaceHolder.text = "Username/Email/Mobile"
        return userName
    }()
    
    let passwordTextField:CustomTextField = {
        let password = CustomTextField()
        password.isSecureTextEntry = true
        password.customLabelPlaceHolder.text = "Password"
        return password
    }()
    
    let loginButton:UIButton = {
        let login = UIButton()
        login.backgroundColor = .white
        login.setTitle("Login", for: .normal)
        login.setTitleColor(.black, for: .normal)
        login.layer.cornerRadius = 20
        login.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        login.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return login
    }()
    
    let signUpButton:UIButton = {
        let signUp = UIButton()
        signUp.backgroundColor = .blue
        signUp.setTitle("Signup", for: .normal)
        signUp.setTitleColor(.white, for: .normal)
        signUp.layer.cornerRadius = 20
        signUp.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        signUp.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return signUp
    }()
    
    lazy var controlsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userNameTextField,passwordTextField,loginButton,spearatorStackView,signUpButton,forgotPasswordLabel,languageLabel])
        stack.axis = .vertical
        stack.spacing = 40
        return stack
    }()
    
    let firstSeparator:UIView = {
        let sep = UIView()
        sep.backgroundColor = .white
        return sep
    }()
    
    let secondSeparator:UIView = {
        let sep = UIView()
        sep.backgroundColor = .white
        return sep
    }()
    
    let orLabel:UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var spearatorStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstSeparator,orLabel,secondSeparator])
        stack.alignment = .center
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupControlsStack()
        addCustomStatusBar()
        addKeyboardObserver()
    }
    func addCustomStatusBar()
    {
        let customBackgroundView = UIView()
        customBackgroundView.backgroundColor = .blue
        let height = UIApplication.shared.statusBarFrame.height
        guard let window = UIApplication.shared.keyWindow else {return}
        window.addSubview(customBackgroundView)
        customBackgroundView.anchorToView(top: window.topAnchor, leading: window.leadingAnchor, bottom: nil, trailing: window.trailingAnchor, padding: .zero, size: .init(width: 0, height: height))
    }
    func setupNavigationBar()
    {
        navigationController?.navigationBar.isHidden = true
    }
    func setupControlsStack()
    {
        view.addSubview(backGroundImage)
        backGroundImage.anchorToView(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        view.addSubview(logoImage)
        view.addSubview(scrollView)
        logoImage.anchorToView(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 150), centerH: true)
        scrollView.anchorToView(top: logoImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 30, bottom: 0, right: 30),size: .init(width: 0, height:0))
       bottomAnchorConstraint =   scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant:30)
        bottomAnchorConstraint!.isActive = true
        scrollView.addSubview(controlsStack)
        controlsStack.anchorToView(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor, padding: .init(top: 30, left: 0, bottom:150, right: 0))
        controlsStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        userNameTextField.anchorToView(size: .init(width: 0, height: 35))
        passwordTextField.anchorToView(size: .init(width: 0, height: 35))
        orLabel.anchorToView(size:.init(width:40, height: 0))
        let width = (view.frame.width - 60 - 40) / 2
        secondSeparator.anchorToView(size: .init(width: width, height: 1))
        firstSeparator.anchorToView(size: .init(width:  width, height: 1))
        loginButton.anchorToView(size: .init(width: 0, height: 45))
        signUpButton.anchorToView(size:.init(width: 0, height: 45))
        //scrollView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        //self.view.setNeedsLayout()
        //self.view.layoutIfNeeded()
        //print(self.scrollView.frame) // gives correct frame
        //print(controlsStack.frame)
        //526

        //scrollView.isScrollEnabled =  checkToEnableScroll()
    }
   /* func checkToEnableScroll() -> Bool
    {
        guard let window = UIApplication.shared.keyWindow else {
            return false
        }
        let height = 20 + 150 + 500 + window.safeAreaInsets.top
        if height >= view.frame.height
        {
            return true
        }
        else
        {
            return false
        }
    }*/
    func addKeyboardObserver()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification)
    {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        let curframe = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let delta = targetFrame.origin.y - curframe.origin.y
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(rawValue: curve!), animations: {
            self.bottomAnchorConstraint?.constant += delta
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
extension LoginController
{
    @objc func handleLogin()
    {
        navigationController?.pushViewController(MainTabBarController(), animated: true)
    }
    @objc func handleSignup()
    {
        navigationController?.pushViewController(SignupController(), animated: true)
    }
}
