//
//  SignupController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/18/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
import FlagPhoneNumber
import ProgressHUD
class SignupController: UIViewController,FPNTextFieldDelegate,UITextFieldDelegate {
    var isValidPhoneNumber:Bool = false
    var ignoreExistanceValidationAfterClicking = false
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool)
    {
        if isValid
        {
            requiredLabel.text = ""
            isValidPhoneNumber = true
        }
        else
        {
            if phoneNumber.text == ""
            {
                requiredLabel.text = NSLocalizedString("Required field", comment: "")
            }
            else
            {
                requiredLabel.text = NSLocalizedString("Enter a valid phone number", comment: "")
            }
            isValidPhoneNumber = false
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
        //scv.contentInsetAdjustmentBehavior = .automatic
        return scv
    }()
    
    let userNameTextField:CustomTextFieldTest = {
        let userName = CustomTextFieldTest()
        userName.textIcon.tintColor = .white
        userName.customLabelPlaceHolder.text = NSLocalizedString("Username", comment: "");
        userName.addTarget(self, action: #selector(validateUserNameOnChange), for: .editingChanged)
        userName.autocapitalizationType = .none
        userName.requiredLabel.font = UIFont.systemFont(ofSize: 13)
        userName.requiredLabel.numberOfLines = -1
        userName.rightView?.isHidden = true
        userName.textFieldIcon.image = UIImage(named: "account")
        return userName
    }()
    //weak medium strong very strong
    let passwordTextField:CustomTextFieldTest = {
        let password = CustomTextFieldTest()
        password.customLabelPlaceHolder.text = NSLocalizedString("Password", comment: "")
        password.addTarget(self, action: #selector(handlePasswordTextChange), for: .editingChanged)
        password.isSecureTextEntry = true
        password.rightViewContainer.isHidden = false
        password.textFieldIcon.image = UIImage(named: "icons8-lock-48")
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
        let attributedString = NSMutableAttributedString(string: NSLocalizedString("I accept", comment: ""), attributes: [:])
        attributedString.append(NSAttributedString(string: "  ",attributes:[:]));
        attributedString.append(NSAttributedString(string: NSLocalizedString("Terms and Conditions", comment: ""), attributes: underlineAttribute))
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
        // phone.parentViewController = self
        phone.setFlag(for: .EG)
        phone.textColor = .white
        phone.isEnabled = true
        phone.isUserInteractionEnabled = true
        phone.hasPhoneNumberExample = false
        phone.attributedPlaceholder =
            NSAttributedString(string: phone.placeholder ?? "Enter a phone number",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]);
        phone.semanticContentAttribute = .forceLeftToRight
        phone.flagPhoneNumberDelegate = self
        return phone
    }()
    let emailTextField:CustomTextFieldTest = {
        let email = CustomTextFieldTest()
        email.textFieldIcon.image =  #imageLiteral(resourceName: "icons8-new-post-filled-50").withRenderingMode(.alwaysTemplate)
        // email.textIcon.image = #imageLiteral(resourceName: "icons8-new-post-filled-50").withRenderingMode(.alwaysTemplate)
        email.textIcon.tintColor = .white
        email.customLabelPlaceHolder.text = NSLocalizedString("Email Address", comment: "")
        email.addTarget(self, action: #selector(handleValidateEmailChange), for: .editingChanged)
        return email
    }()
    
    let createAccountButton:UIButton = {
        let createAccount = UIButton()
        createAccount.backgroundColor = .white
        createAccount.setTitle(NSLocalizedString("Create Account", comment: "") , for: .normal)
        createAccount.setTitleColor(.black, for: .normal)
        createAccount.layer.cornerRadius = 20
        createAccount.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        createAccount.addTarget(self, action: #selector(handleCreateAccount), for: .touchUpInside)
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
        label.text = NSLocalizedString("Already have an account", comment: "") 
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
        addKeyboardObserver()
        navigationController?.navigationBar.isHidden = true
    }
    var bottomAnchorConstraint:NSLayoutConstraint?
    func setupViews()
    {
        view.addSubview(backGroundImage)
        view.addSubview(logoImage)
        view.addSubview(scrollView)
        
        scrollView.addSubview(controlsStack)
        
        backGroundImage.anchorToView(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        logoImage.anchorToView(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 150), centerH: true)
        
        scrollView.anchorToView(top: logoImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 30, bottom: 0, right: 30),size: .init(width: 0, height:0))
        
        bottomAnchorConstraint =  //scrollView.heightAnchor.constraint(equalToConstant:570)
            //scrollView.backgroundColor = .red
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant:0)
        
        bottomAnchorConstraint!.isActive = true
        
        controlsStack.anchorToView(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor, padding: .init(top: 30, left: 0, bottom:150, right: 0))
        
        controlsStack.widthAnchor.constraint(equalTo:
            scrollView.widthAnchor).isActive = true
        
        userNameTextField.anchorToView(size: .init(width: 0, height: 35))
        
        passwordTextField.anchorToView(size: .init(width: 0, height: 35))
        
        emailTextField.anchorToView(size: .init(width: 0, height: 35))
        
        createAccountButton.anchorToView(size: .init(width: 0, height: 45))
        
        passwordPercentageBackground.anchorToView(size: .init(width: 0, height: 4))
        
        phoneNumber.anchorToView(size:.init(width: 0, height: 35))
        
        phoneNumber.addSubview(bottomSeparator)
        
        self.view.addSubview(requiredLabel)
        
        bottomSeparator.anchorToView(top: nil, leading: phoneNumber.leadingAnchor, bottom: phoneNumber.bottomAnchor, trailing: phoneNumber.trailingAnchor, padding: .zero, size: .init(width: 0, height: 2))
        
        requiredLabel.anchorToView(top: phoneNumber.bottomAnchor, leading: emailTextField.leadingAnchor)
        
        termsAndConditionsStack.anchorToView(size:.init(width: 0, height: 25))
        checkButton.anchorToView(size:.init(width: 25, height: 0))
    }
    //handlers
    @objc func handlePasswordTextChange()
    {
        let _ = validatePassword()
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        let text = phoneNumber.placeholder ?? "Enter a phone number"
        let attributedString = NSAttributedString(string: text,
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        phoneNumber.attributedPlaceholder = attributedString
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 0, height: 570)
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
    @objc func handleCreateAccount(sender:UIButton)
    {
        sender.isEnabled = false
        ignoreExistanceValidationAfterClicking = true
        isValidForm { (formIsValid) in
            if formIsValid
            {
                ProgressHUD.show()
                Auth.auth().createUser(withEmail: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { (result, err) in
                    if err != nil
                    {
                        ProgressHUD.showError(err?.localizedDescription)
                        sender.isEnabled = true
                        return
                    }
                    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
                    guard let fullPhone = self.phoneNumber.getFormattedPhoneNumber(format: .E164) else {return}
                    guard let currentAppLanguage = NSLocale.current.languageCode else {return}
                   // currentUserInfo.getIDToken(completion: { (token, err) in
                        if err != nil
                        {
                            ProgressHUD.showError(err?.localizedDescription)
                            sender.isEnabled = true
                        }
                        let privateData = ["birth_date":"","gender":"","language":currentAppLanguage,"phone_number":fullPhone,"register_date":Date().timeIntervalSince1970] as [String : Any]
                        let allValues = ["email":self.emailTextField.text!,"full_name":"","full_phone":fullPhone,"location":"","phone":self.phoneNumber.getRawPhoneNumber() ?? "","phone_country":self.getCountryCode(),"picture":"","picture_path":"","private_data":privateData,"profile_is_private":false,"status":"","uid":currentUserID,"user_name":self.userNameTextField.text ?? "","user_token":Messaging.messaging().fcmToken ?? ""] as [String : Any]
                        
                        let toUpdateValues = [currentUserID:allValues]; Database.database().reference().child("Users").updateChildValues(toUpdateValues, withCompletionBlock: { (err, ref) in
                            if err != nil
                            {
                                ProgressHUD.showError(err?.localizedDescription)
                                return
                            }
                            else
                            {
                                
                                self.goToHomePage()
                            }
                      //  })
                    })
                }
                
            }
            else
            {
                sender.isEnabled = true
            }
        }
    }
    
    @objc func getCountryCode() -> String
    {
        guard let phone = self.phoneNumber.getFormattedPhoneNumber(format: .International) else {return ""}
        let arr = phone.split(separator: " ")
        print(String(arr[0]))
        return String(arr[0])
    }
    
    @objc func validateUserNameOnChange()
    {
        self.validateUserName { (valid) in
            if valid
            {
                self.userNameTextField.rightView?.isHidden = false
                self.userNameTextField.rightViewImage.image = #imageLiteral(resourceName: "trillLogo")
            }
            else
            {
                self.userNameTextField.rightView?.isHidden = true
            }
        }
    }
    func validateUserName(completitionHandler:@escaping (Bool) -> ())
    {
        userNameTextField.requiredLabel.isHidden = false
        
        if userNameTextField.text == ""
        {
            completitionHandler(false)
            userNameTextField.requiredLabel.isHidden = false
            userNameTextField.requiredLabel.text = NSLocalizedString("Required field", comment: "")
        }
        else
        {
            
            if let count =  userNameTextField.text?.count , count >= 5
            {
                if var username = userNameTextField.text, username != ""
                {
                    username = username.trimmingCharacters(in: .whitespacesAndNewlines)
                    userNameTextField.text = username
                    if !isValidUsernameFunction(input: username)
                    {
                        completitionHandler(false)
                        userNameTextField.requiredLabel.text = NSLocalizedString("User Name Only can have small english letter,number", comment: "")
                    }
                    else
                    {
                        
                        FirebaseService.getUserBy(userName: username.lowercased()) { (user) in
                            if user != nil
                            {
                                if self.ignoreExistanceValidationAfterClicking == false
                                {
                                    self.userNameTextField.requiredLabel.text = NSLocalizedString("Username found", comment: "") 
                                    completitionHandler(false)
                                }
                                
                            }
                            else
                            {
                                self.userNameTextField.requiredLabel.text = ""
                                completitionHandler(true)
                            }
                        }
                    }
                }
                
            }
            else
            {
                userNameTextField.requiredLabel.text = NSLocalizedString("Must be at least 5 characters and up", comment: "")
            }
        }
    }
    func isValidUsernameFunction(input: String) -> Bool
    {
        do
        {
            let regex = try NSRegularExpression(pattern: "^[0-9a-z\\_\\-]{5,18}$"
                , options: [])
            if regex.matches(in: input, options: [], range: NSMakeRange(0, input.count)).count > 0
            {
                let charset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
                if input.rangeOfCharacter(from: charset) == nil {
                    return false
                }
                return true
            }
        }
        catch {}
        return false
    }
    @objc func handleValidateEmailChange()
    {
        let isValidEmail = validateEmail()
        if isValidEmail
        {
            checkIfEmailAlreadyExists { (user) in
                if user == nil
                {
                    self.emailTextField.requiredLabel.isHidden = true
                }
                else
                {
                    if self.ignoreExistanceValidationAfterClicking == false
                    {
                        self.emailTextField.requiredLabel.text = "Email Exist"
                        self.emailTextField.requiredLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func validatePassword() -> Bool
    {
        let numbersCharset = CharacterSet.decimalDigits
        let alphabeticalSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        let password = passwordTextField.text ?? ""
        if password.count == 0
        {
            passwordTextField.requiredLabel.isHidden = false
            passwordTextField.requiredLabel.text = NSLocalizedString("Required field", comment: "")
        }
        else if password.count > 0 && password.count < 6
        {
            passwordTextField.requiredLabel.text = NSLocalizedString("Password must be 6 charachters and up", comment: "") 
            passwordStregnthLabel.text = NSLocalizedString("Weak", comment: "")
            passwordPercentageBackground.backgroundColor = .red
        }
        else if password.count >= 6
        {
            if password.rangeOfCharacter(from: numbersCharset) == nil
            {
                passwordTextField.requiredLabel.isHidden = false
                passwordTextField.requiredLabel.text = NSLocalizedString("Password should contain at least one Number", comment: "")//"Password should contain at least one Number"
                return false
            }
            else if password.rangeOfCharacter(from: alphabeticalSet) == nil
            {
                passwordTextField.requiredLabel.isHidden = false
                passwordTextField.requiredLabel.text = NSLocalizedString("Password should containt at least one small charachter", comment: "")
                return false
            }
            else
            {
                passwordStregnthLabel.text = NSLocalizedString("Medium", comment: "")
                passwordTextField.requiredLabel.text = ""
            }
            if password.count <= 12
            {
                passwordPercentageBackground.backgroundColor = .orange
            }
            else if password.count > 12 && password.count < 18
            {
                passwordStregnthLabel.text = NSLocalizedString("Strong", comment: "")
                passwordPercentageBackground.backgroundColor = .green
            }
            else if password.count >= 18
            {
                passwordStregnthLabel.text = "Very Strong"
                passwordPercentageBackground.backgroundColor = .blue
            }
            return true
        }
        return false
    }
    func validateEmail() -> Bool
    {
        if emailTextField.text == ""
        {
            emailTextField.requiredLabel.isHidden = false
            emailTextField.requiredLabel.text = NSLocalizedString("Required field", comment: "")// "required"
        }
        else
        {
            guard let email = emailTextField.text else {return false}
            if isValidEmail(testStr: email)
            {
                //emailTextField.requiredLabel.isHidden = true
                return true
            }
            else
            {
                emailTextField.requiredLabel.isHidden = false
                emailTextField.requiredLabel.text = NSLocalizedString("Input Error", comment: "") 
            }
        }
        return false
    }
    func checkIfEmailAlreadyExists(completitionHandler:@escaping (User?) -> ())
    {
        let ref = Database.database().reference().child("Users")
        let query = ref.queryOrdered(byChild: "email").queryEqual(toValue: emailTextField.text ?? "")
        query.observe(.value) { (snap) in
            if snap.value is NSNull
            {
                completitionHandler(nil)
            }
        }
        query.observeSingleEvent(of:.childAdded, with: { (snap) in
            if let dictionary = snap.value as? [String:Any]
            {
                let user = User(dictionary: dictionary)
                completitionHandler(user)
            }
            else
            {
                completitionHandler(nil)
            }
        }) { (err) in
            
        }
    }
    func isValidForm(completitionHandler: @escaping (Bool) -> ())
    {
        if checkButton.isSelected
        {
            validateUserNameOnChange()
            handleValidateEmailChange()
            handlePasswordTextChange()
            if !isValidPhoneNumber
            {
                if phoneNumber.text == ""
                {
                    requiredLabel.text = NSLocalizedString("Required field", comment: "")
                }
                else
                {
                    requiredLabel.text = NSLocalizedString("Enter a valid phone number", comment: "")
                }
            }
            validateUserName { (validUser) in
                if !validUser
                {
                    self.ignoreExistanceValidationAfterClicking = false
                    completitionHandler(false)
                }
                else
                {
                    if self.validateEmail()
                    {
                        if self.validatePassword()
                        {
                            if self.isValidPhoneNumber
                            {
                                self.checkIfEmailAlreadyExists(completitionHandler: { (user) in
                                    if user == nil
                                    {
                                        self.emailTextField.requiredLabel.isHidden = true
                                        completitionHandler(true)
                                    }
                                    else
                                    {
                                        self.ignoreExistanceValidationAfterClicking = false;                                        completitionHandler(false)
                                    }
                                })
                            }
                            else
                            {
                                self.ignoreExistanceValidationAfterClicking = false;
                                completitionHandler(false)
                                if self.phoneNumber.text == ""
                                {
                                    self.requiredLabel.text = NSLocalizedString("Required field", comment: "")
                                }
                                else
                                {
                                    self.requiredLabel.text = NSLocalizedString("Enter a valid phone number", comment: "")
                                }
                            }
                        }
                        else
                        {
                            self.ignoreExistanceValidationAfterClicking = false
                            completitionHandler(false)
                        }
                    }
                    else
                    {
                        self.ignoreExistanceValidationAfterClicking = false
                        completitionHandler(false)
                    }
                }
            }
        }
        else
        {
            self.ignoreExistanceValidationAfterClicking = false
            ProgressHUD.showError("You must accept terms and conditions")
            completitionHandler(false)
        }
    }
    //will be changed to go to fill in the rest of the info page
    func goToHomePage()
    {
        ProgressHUD.dismiss()
        let completeSignUp = CompleteSignUp()
        self.navigationController?.pushViewController(completeSignUp, animated: true)
      
    }
}
