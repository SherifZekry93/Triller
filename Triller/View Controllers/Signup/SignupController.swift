//
//  SignupController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/18/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import FlagPhoneNumber
class SignupController: UIViewController,FPNTextFieldDelegate {
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool)
    {
        if isValid
        {
            requiredLabel.text = ""
        }
        else
        {
            if phoneNumber.text == ""
            {
                requiredLabel.text = "Required"
            }
            else
            {
                requiredLabel.text = "Please enter a valid number"
            }
        }
    }
    
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
    //weak medium strong very strong
    let passwordTextField:CustomTextField = {
        let password = CustomTextField()
        password.customLabelPlaceHolder.text = "Password"
        password.addTarget(self, action: #selector(handlePasswordTextChange), for: .editingChanged)
        password.isSecureTextEntry = true
        password.rightViewContainer.isHidden = false
        return password
    }()
    let bottomSeparator:UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.82, alpha: 1)
        return separator
    }()
    
    let checkButton:UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(toggleCheckBox), for: .touchUpInside)
        return button
    }()
    
    lazy var termsAndConditionsLabel:UILabel = {
        let termsAndConditions = UILabel()
        termsAndConditions.isUserInteractionEnabled = true
        //termsAndConditions.text = "Terms and Conditions"
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedString = NSMutableAttributedString(string: "I accept ", attributes: [:])
        attributedString.append(NSAttributedString(string: "Terms and Conditions", attributes: underlineAttribute))
        termsAndConditions.attributedText = attributedString
        termsAndConditions.textAlignment = .center
        termsAndConditions.font = UIFont.boldSystemFont(ofSize: 15)
        termsAndConditions.textColor = .white;
    termsAndConditions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToTermsAndConditionsURL)))
        return termsAndConditions
    }()
    
    lazy var termsAndConditionsStack:UIStackView = {
       let stack = UIStackView(arrangedSubviews: [checkButton,termsAndConditionsLabel])
        stack.spacing = 4
        return stack
    }()
    
    lazy var phoneNumber:FPNTextField = {
        let phone = FPNTextField()
        phone.parentViewController = self
        phone.setFlag(for: .EG)
        phone.textColor = .white
        phone.isEnabled = true
        phone.isUserInteractionEnabled = true
        phone.hasPhoneNumberExample = false
        phone.attributedPlaceholder =
            NSAttributedString(string: phone.placeholder ?? "Enter a phone number",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]);
        phone.flagPhoneNumberDelegate = self
        return phone
    }()
    let emailTextField:CustomTextField = {
        let email = CustomTextField()
        email.textIcon.image = #imageLiteral(resourceName: "love").withRenderingMode(.alwaysTemplate)
        email.textIcon.tintColor = .white
        email.customLabelPlaceHolder.text = "email"
        return email
    }()
    
    let createAccountButton:UIButton = {
        let createAccount = UIButton()
        createAccount.backgroundColor = .white
        createAccount.setTitle("Create Account", for: .normal)
        createAccount.setTitleColor(.black, for: .normal)
        createAccount.layer.cornerRadius = 20
        createAccount.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        return createAccount
    }()
    
    let passwordPercentageBackground:UIView = {
        let passwordPercentage = UIView()
        passwordPercentage.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return passwordPercentage
    }()
    
    let passwordStregnthLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    lazy var stackForPasswordStrength:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [passwordPercentageBackground,passwordStregnthLabel])
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    lazy var controlsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userNameTextField,passwordTextField,stackForPasswordStrength,emailTextField,phoneNumber,termsAndConditionsStack,createAccountButton,alreadyHaveAnAccount])
        stack.axis = .vertical
        stack.spacing = 40
        return stack
    }()
    
    let requiredLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var alreadyHaveAnAccount:UILabel = {
       let label = UILabel()
       label.text = "Already have an account"
       label.font = UIFont.systemFont(ofSize: 15)
       label.textColor = .white
       label.isUserInteractionEnabled = true
       label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAlreadyHaveAnAccount)))
       label.textAlignment = .center
       return label
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
        navigationController?.navigationBar.isHidden = true
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
        
        controlsStack.anchorToView(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, padding: .init(top: 30, left: 0, bottom:150, right: 0))
        
        controlsStack.widthAnchor.constraint(equalTo:
            scrollView.widthAnchor).isActive = true
        
        userNameTextField.anchorToView(size: .init(width: 0, height: 35))
        
        passwordTextField.anchorToView(size: .init(width: 0, height: 35))
        
        emailTextField.anchorToView(size: .init(width: 0, height: 35))
        
        createAccountButton.anchorToView(size: .init(width: 0, height: 45))
        
        passwordPercentageBackground.anchorToView(size: .init(width: 0, height: 4))
        
        phoneNumber.anchorToView(size:.init(width: 0, height: 35))
        
        phoneNumber.addSubview(bottomSeparator)
        
        phoneNumber.addSubview(requiredLabel)
        
        bottomSeparator.anchorToView(top: nil, left: phoneNumber.leftAnchor, bottom: phoneNumber.bottomAnchor, right: phoneNumber.rightAnchor, padding: .zero, size: .init(width: 0, height: 2))
        
        requiredLabel.anchorToView(top: phoneNumber.bottomAnchor, left: phoneNumber.leftAnchor)
        
        termsAndConditionsStack.anchorToView(size:.init(width: 0, height: 25))
        checkButton.anchorToView(size:.init(width: 25, height: 0))
    }
    //handlers
    @objc func handlePasswordTextChange()
    {
        let password = passwordTextField.text ?? ""
        
        if password.count >= 0 && password.count <= 6
        {
            passwordStregnthLabel.text = "Weak"
            passwordPercentageBackground.backgroundColor = .red
        }
            
        else if password.count > 6 && password.count <= 12
        {
            passwordStregnthLabel.text = "Medium"
            passwordPercentageBackground.backgroundColor = .orange
        }
            
        else if password.count > 12 && password.count < 18
        {
            passwordStregnthLabel.text = "Strong"
            passwordPercentageBackground.backgroundColor = .green
        }
            
        else
        {
            passwordStregnthLabel.text = "Very Strong"
            passwordPercentageBackground.backgroundColor = .blue
        }
    }
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        let text = phoneNumber.placeholder ?? "Enter a phone number"
        let attributedString = NSAttributedString(string: text,
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        phoneNumber.attributedPlaceholder = attributedString
    }
    
    @objc func goToTermsAndConditionsURL()
    {
        if let url = URL(string: "http://trillzapp.com/terms.php?lang=en") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func toggleCheckBox(_ sender:UIButton)
    {
        sender.isSelected = !sender.isSelected
        let isSelected = sender.isSelected
        checkButton.setImage(isSelected ? #imageLiteral(resourceName: "Checkbox").withRenderingMode(.alwaysOriginal) : nil, for: .normal)
    }
    @objc func handleAlreadyHaveAnAccount()
    {
        navigationController?.popViewController(animated: true)
    }
}
