//
//  LoginController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/18/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import MOLH
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
        return scv
    }()
    
    lazy var forgotPasswordLabel:UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Forgot Password?", comment: "")
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleForgetPassword)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var languageLabel:UILabel = {
        let label = UILabel()
        label.text = MOLHLanguage.currentAppleLanguage() == "ar" ? "English" : "العربية"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchLanguages)))
        return label
    }()
    
    let userNameTextField:CustomTextFieldTest = {
        let userName = CustomTextFieldTest()
        userName.textFieldIcon.image = UIImage(named: "account")
        userName.textIcon.tintColor = .white
        userName.customLabelPlaceHolder.text = NSLocalizedString("Username/Email/Mobile", comment: "")
        userName.requiredLabel.text = NSLocalizedString("Required field", comment: "")
        return userName
    }()
    
    let passwordTextField:CustomTextFieldTest = {
        let password = CustomTextFieldTest()
        password.textFieldIcon.image = UIImage(named: "icons8-lock-48")
        password.isSecureTextEntry = true
        password.customLabelPlaceHolder.text = NSLocalizedString("Password", comment: "")
        //password.textAlignment = .center
        return password
    }()
    
    let loginButton:UIButton = {
        let login = UIButton()
        login.backgroundColor = .white
        login.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        login.setTitleColor(.black, for: .normal)
        login.layer.cornerRadius = 20
        login.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        login.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return login
    }()
    lazy var reduceSpacingStackView:UIStackView = {
        let reduce = UIStackView(arrangedSubviews: [loginButton,spearatorStackView,signUpButton])
        reduce.axis = .vertical
        reduce.spacing = 10
        return reduce
    }()
    let signUpButton:UIButton = {
        let signUp = UIButton()
        signUp.backgroundColor = .blue
        signUp.setTitle(NSLocalizedString("Signup", comment: ""), for: .normal)
        signUp.setTitleColor(.white, for: .normal)
        signUp.layer.cornerRadius = 20
        signUp.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        signUp.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return signUp
    }()
    
    lazy var controlsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userNameTextField,passwordTextField,reduceSpacingStackView,forgotPasswordLabel,languageLabel])
        stack.axis = .vertical
        stack.spacing = 37.5
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
        label.text = NSLocalizedString("OR", comment: "") 
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
        //checkIfLoggedIn()
        setupNavigationBar()
        setupControlsStack()
        //addCustomStatusBar()
        addKeyboardObserver()
        //view.fixSafeArea(color: .blue)
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
        bottomAnchorConstraint =   scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        loginButton.anchorToView(size: .init(width: 0, height: 40))
        signUpButton.anchorToView(size:.init(width: 0, height: 40))
        setupTextFieldIconsStack()
    }
    func setupTextFieldIconsStack()
    {
        //userNameLineView.anchorToView(size:.init(width: 0, height: 1))
        //usernameIcon.anchorToView(size:.init(width: 35, height: 35))
    }
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        //original height is 450
        scrollView.contentSize = CGSize(width: 0, height: 420)
    }
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
        if var userNameEmailTextField = userNameTextField.text, let password = passwordTextField.text, userNameEmailTextField != "", password != "", password.count >= 6
        {
            ProgressHUD.show("Logging in")
            if isValidEmail(testStr: userNameEmailTextField)
            {
                self.view.endEditing(true)
                finalLoginToFirebase(email: userNameEmailTextField, password: password)
            }
            else if userNameEmailTextField.isNumber
            {
            userNameEmailTextField.remove(at: userNameEmailTextField.startIndex)
                FirebaseService.getUserBy(phoneNumber: userNameEmailTextField) { (user) in
                    if let user = user
                    {
                        self.view.endEditing(true)
                        self.finalLoginToFirebase(email: user.email, password: password)
                    }
                    else
                    {
                        self.view.endEditing(true)
                        ProgressHUD.showError("number not found")
                    }
                }
            }
            else
            {
                FirebaseService.getUserBy(userName: userNameEmailTextField) { (user) in
                    if let user = user
                    {
                        self.view.endEditing(true)
                        self.finalLoginToFirebase(email: user.email, password: password)
                    }
                    else
                    {
                        self.view.endEditing(true)
                        ProgressHUD.showError("Username Not Found")
                    }
                }
            }
        }
       
        userNameTextField.requiredLabel.isHidden =  userNameTextField.text == "" ? false : true
        passwordTextField.requiredLabel.isHidden =  passwordTextField.text == "" ? false : true
        guard let count = passwordTextField.text?.count else {return}
        if count > 0 && count < 6
        {
            passwordTextField.requiredLabel.isHidden = false
            passwordTextField.requiredLabel.text = "Incorrect format"
        }
        else
        {
            passwordTextField.requiredLabel.text = NSLocalizedString("Required field", comment: "")
        }
        
    }
    
    @objc func handleSignup()
    {
        self.view.endEditing(true)
        navigationController?.pushViewController(SignupController(), animated: true)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func goToHomePage()
    {
        ProgressHUD.dismiss()
        let tabbar = MainTabBarController()
        self.navigationController?.pushViewController(tabbar, animated: true)
    }
    func finalLoginToFirebase(email:String,password:String)
    {
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil
            {
                ProgressHUD.showError(err?.localizedDescription)
                return
            }
            self.goToHomePage()
        }
    }
    @objc func handleForgetPassword()
    {
        let alert = UIAlertController(title: "Enter your e-mail", message: nil, preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "mail@mail.com"//text = "Some default text"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            // Force unwrapping because we know it exists.
            if let  textField = alert?.textFields?[0]
            {
                guard let email = textField.text else {return}
                if self.isValidEmail(testStr: email)
                {
                    Auth.auth().sendPasswordReset(withEmail: email)
                    { error in
                        if error != nil
                        {
                            ProgressHUD.showError(error?.localizedDescription)
                            return
                        }
                        self.showToast(message: "Check your mail!")
                    }

                }
                else
                {
                    ProgressHUD.showError("Incorrect E-mail Format")
                }
//                guard let user = self.user else {return}
//                guard let newPassword = self.passwordTextField.text else {return}
                //                self.changePassword(email: user.email, currentPassword: textField.text ?? "" , newvarsword: newPassword, completion: { (err) in
//                })
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)

    }
    @objc func switchLanguages()
    {
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        MOLH.reset(transition: .transitionFlipFromRight)
    }
}
