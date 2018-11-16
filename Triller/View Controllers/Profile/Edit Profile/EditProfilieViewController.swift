//
//  EditProfilieViewController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/23/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import SDWebImage
class EditProfileViewController: UIViewController
{
    var imageWasChanged = false
    lazy var profilePicture:UIImageView = {
        let image = UIImageView()
        image.sd_setIndicatorStyle(.gray)
        image.sd_showActivityIndicatorView()
        image.contentMode = .scaleAspectFill//Fit
        image.layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPhotoSelector)))
        image.layer.cornerRadius = 60
        image.clipsToBounds = true
        return image
    }()
    let changeProfileLabel:UILabel = {
        let label = UILabel()
        label.text = "Change Profile Picture"
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    lazy var imageContainerStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profilePicture,changeProfileLabel])
        stack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPhotoSelector)))
        stack.isUserInteractionEnabled = true
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    let fullNameText:CustomTextField = {
        let text = CustomTextField()
        text.customLabelPlaceHolder.text = "Full Name"
        text.isEditProfile = true
        text.customLabelPlaceHolder.textColor = .red
        text.bottomSeparator.backgroundColor = .red
        return text
    }()
    
    let statusText:CustomTextField = {
        let status = CustomTextField()
        status.text = "Happpy"
        status.customLabelPlaceHolder.text = "Status"
        status.isEditProfile = true
        return status
    }()
    
    let passwordTextField:CustomTextField = {
        let password = CustomTextField()
        password.customLabelPlaceHolder.text = "Password"
        password.isSecureTextEntry = true
        password.isEditProfile = true
        password.addTarget(self, action: #selector(handlePasswordTextChange), for: .editingChanged)
        password.requiredLabel.textColor = .red
        password.requiredLabel.isHidden = false
        return password
    }()
    
    lazy var infoStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullNameText,statusText,passwordTextField,stackForPasswordStrength])
        stack.axis = .vertical
        stack.spacing = 37.5
        stack.distribution = .fillEqually
        return stack
    }()
    
    let PrivateInformationLabel:UILabel = {
        let label = UILabel()
        label.text = "PRIVATE INFORMATION"
        label.textAlignment = .center
        return label
    }()
    
    lazy var privateInfoStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTextField,phoneTextField,genderTextField,languageTextField])
        stack.axis = .vertical
        stack.spacing = 37.5
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var imagePickerController:UIImagePickerController = {
        let profileImagePicker = UIImagePickerController()
        profileImagePicker.delegate = self
        profileImagePicker.allowsEditing = true
        return profileImagePicker
    }()
    
    let emailTextField:CustomTextField = {
        let text = CustomTextField()
        text.customLabelPlaceHolder.text = "Email"
        text.isEnabled = false
        text.text = "some-mail@mail.com"
        text.isEditProfile = true
        return text
    }()
    
    let phoneTextField:CustomTextField = {
        let text = CustomTextField()
        text.customLabelPlaceHolder.text = "Phone Number"
        text.isEnabled = false
        text.text = "Phone..."
        text.isEditProfile = true
        return text
    }()
    
    lazy var genderTextField:CustomTextField = {
        let text = CustomTextField()
        text.customLabelPlaceHolder.text = "Gender"
        text.isEnabled = false
        text.text = "Male"
        text.isEditProfile = true
        return text
    }()
    
    let languageTextField:CustomTextField = {
        let text = CustomTextField()
        text.customLabelPlaceHolder.text = "Language"
        text.isEnabled = false
        text.text = "English"
        text.isEditProfile = true
        return text
    }()
    
    let selectGenderButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(showGenderSelection), for: .touchUpInside)
        button.alpha = 0.1
        return button
    }()
    
    let selectLanguageButton:UIButton = {
        let button = UIButton()
        //button.alpha = 1
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(showLanguageSelection), for: .touchUpInside)
        button.alpha = 0.1
        return button
    }()
    let scrollView:UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    let passwordPercentageBackground:UIView = {
        let passwordPercentage = UIView()
        passwordPercentage.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return passwordPercentage
    }()
    
    let passwordStregnthLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    lazy var stackForPasswordStrength:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [passwordPercentageBackground,passwordStregnthLabel])
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()

    var user:User?{
        didSet{
            guard let user = user else {return}
            fullNameText.text = user.full_name
            statusText.text = user.status
            emailTextField.text = user.email
            phoneTextField.text = "0" + user.phone
            genderTextField.text = user.private_data.gender
            print(user.picture_path)
            if let actualPath = URL(string: user.picture_path)
            {
            profilePicture.sd_setImage(with: actualPath) { (_, err, _, _) in
                if err != nil
                {
                    self.profilePicture.image = #imageLiteral(resourceName: "profile-imag")
                    return
                }
            }
            }
            else
            {
                self.profilePicture.image = #imageLiteral(resourceName: "profile-imag")
            }
            //profilePicture.sd_setImage(with: actualPath, completed: nil)
            guard let currentAppLanguage = NSLocale.current.languageCode else {return}
            if user.private_data.language == ""
            {
                if currentAppLanguage == "en"
                {
                    languageTextField.text = "English"
                }
                else if currentAppLanguage == "ar"
                {
                    languageTextField.text = "Arabic"
                }
            }
            else
            {
                if user.private_data.language == "en"
                {
                    languageTextField.text = "English"
                }
                else if user.private_data.language == "ar"
                {
                    languageTextField.text = "Arabic"
                }
            }
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.98, alpha: 1)
        setupViews()
        setupNavigationItem()
        guard let uid =  Auth.auth().currentUser?.uid else {return}
        FirebaseService.fetchUserByuid(uid: uid) { (user) in
            self.user = user
        }
        fullNameText.becomeFirstResponder()
    }
    let fullPageContainerView:UIView = {
        let view = UIView()
        return view
    }()
    func setupViews()
    {
        view.addSubview(scrollView)
        scrollView.anchorToView(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.addSubview(imageContainerStack)
        imageContainerStack.anchorToView(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width:0,height:150))
        profilePicture.anchorToView(size:.init(width: 120, height: 120))
        imageContainerStack.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        scrollView.addSubview(infoStack)
        infoStack.anchorToView(top: imageContainerStack.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 45, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 140 + (37.5 * 3)))
        scrollView.addSubview(PrivateInformationLabel)
        PrivateInformationLabel.anchorToView(top: infoStack.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        scrollView.addSubview(privateInfoStack)
        privateInfoStack.anchorToView(top: PrivateInformationLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 45, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 140 + (37.5 * 3)))
        view.addSubview(selectGenderButton)
        selectGenderButton.anchorToView(top: genderTextField.topAnchor, leading: genderTextField.leadingAnchor, bottom: genderTextField.bottomAnchor, trailing: genderTextField.trailingAnchor)
        view.addSubview(selectLanguageButton)
        selectLanguageButton.anchorToView(top: languageTextField.topAnchor, leading: languageTextField.leadingAnchor, bottom: languageTextField.bottomAnchor, trailing: languageTextField.trailingAnchor)
        passwordPercentageBackground.anchorToView(size:.init(width: 0, height: 3))
    }
    func setupNavigationItem()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleConfirmEdit))
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSize(width: 0, height: 850)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    @objc func showGenderSelection()
    {
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        
        let maleAction = UIAlertAction(title: "Male", style: .default) { (action) in
            self.genderTextField.text = "Male"
        }
        
        let femaleAction = UIAlertAction(title: "Female", style: .default) { (action) in
            self.genderTextField.text = "Female"
        }
        
        alert.addAction(maleAction)
        alert.addAction(femaleAction)
        present(alert, animated: true){
            alert.view.superview?.subviews.first?.isUserInteractionEnabled = true
            alert.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
        }
    }
    @objc func actionSheetBackgroundTapped()
    {
        dismiss(animated: true, completion: nil)
    }
    @objc func showLanguageSelection()
    {
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        let maleAction = UIAlertAction(title: "English", style: .default) { (action) in
            self.languageTextField.text = "English"
        }
        let femaleAction = UIAlertAction(title: "Arabic", style: .default) { (action) in
            self.languageTextField.text = "Arabic"
        }
        alert.addAction(maleAction)
        alert.addAction(femaleAction)
        present(alert, animated: true){
            alert.view.superview?.subviews.first?.isUserInteractionEnabled = true
            alert.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
            
        }
    }
    @objc func handleConfirmEdit()
    {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        if imageWasChanged
        {
            ProgressHUD.show("Uploading Image")
            let imageName = "profile-image.png"
            let uploadFilePath = "\(currentUserID)/UserImege/\(imageName)"
            let storageRef = Storage.storage().reference(withPath:uploadFilePath)
            guard let image = self.profilePicture.image else {return}
            guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
            storageRef.putData(uploadData, metadata: nil) { (data, err) in
                if err != nil
                {
                    ProgressHUD.showError("Failed to update data")
                    return
                }
                storageRef.downloadURL(completion: { (url, err) in
                    if err != nil
                    {
                        ProgressHUD.showError("Failed To update data")
                        return
                    }
                    ProgressHUD.showSuccess("Uploaded")
                    guard let url = url else {return}
                    self.uploadNewUserInfo(url: url.absoluteString)
                })
            }
        }
        
        else
        {
            let user = self.user
            guard let picturePath = user?.picture_path else {return}
            uploadNewUserInfo(url: picturePath)
        }
        
    }
    func uploadNewUserInfo(url:String)
    {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        guard let currentAppLanguage = NSLocale.current.languageCode else {return}
        guard let user = self.user else {return}
        let gender = self.genderTextField.text ?? ""
        let fullName = self.fullNameText.text ?? ""
        let status = self.statusText.text ?? ""
        let privateData = ["birth_date":user.private_data.birth_date.millisecondsSince1970,"gender":gender,"language":currentAppLanguage,"phone_number":user.private_data.phone_number,"register_date":user.private_data.register_date.millisecondsSince1970] as [String : Any]
        let allValues = ["email":user.email,"full_name":fullName,"full_phone":user.full_phone,"location":"","phone":user.phone,"phone_country":user.phone_country,"picture":"profile-image.png","picture_path":url,"private_data":privateData,"profile_is_private":false,"status":status,"uid":currentUserID,"user_name":user.user_name,"user_token":Messaging.messaging().fcmToken ?? ""] as [String : Any]
        
        let toUpdateValues = [currentUserID:allValues]; Database.database().reference().child("Users").updateChildValues(toUpdateValues, withCompletionBlock: { (err, ref) in
            if err != nil
            {
                ProgressHUD.showError(err?.localizedDescription)
                return
            }
            else
            {
                if self.validatePassword()
                {
                    self.confirmPassword()
                }
                else
                {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })

    }
    @objc func confirmPassword()
    {
        let alert = UIAlertController(title: "Confirm Password", message: "Enter old Password", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Old Password"//text = "Some default text"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            // Force unwrapping because we know it exists.
            if let  textField = alert?.textFields?[0]
            {
                guard let user = self.user else {return}
                guard let newPassword = self.passwordTextField.text else {return}
                self.changePassword(email: user.email, currentPassword: textField.text ?? "" , newPassword: newPassword, completion: { (err) in
                })
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)

//        print("showing alert with text field")
    }
    @objc func handlePasswordTextChange()
    {
        let _ = validatePassword()
    }
    func validatePassword() -> Bool
    {
        let numbersCharset = CharacterSet.decimalDigits
        let alphabeticalSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        let password = passwordTextField.text ?? ""
        if password.count == 0
        {
            passwordTextField.requiredLabel.isHidden = false
            passwordTextField.requiredLabel.text = "required"
        }
        else if password.count > 0 && password.count < 6
        {
            passwordTextField.requiredLabel.text = "Password mut be 6 charachters and up"
            passwordStregnthLabel.text = "Weak"
            passwordPercentageBackground.backgroundColor = .red
        }
        else if password.count >= 6
        {
            if password.rangeOfCharacter(from: numbersCharset) == nil
            {
                passwordTextField.requiredLabel.isHidden = false
                passwordTextField.requiredLabel.text = "Password should contain at least one Number"
                return false
            }
            else if password.rangeOfCharacter(from: alphabeticalSet) == nil
            {
                passwordTextField.requiredLabel.isHidden = false
                passwordTextField.requiredLabel.text = "Password should contain at least one small charachter"
                return false
            }
            else
            {
                passwordStregnthLabel.text = "Medium"
                passwordTextField.requiredLabel.text = ""
            }
            if password.count <= 12
            {
                passwordPercentageBackground.backgroundColor = .orange
            }
            else if password.count > 12 && password.count < 18
            {
                passwordStregnthLabel.text = "Strong"
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
    typealias Completion = (Error?) -> Void
    
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping Completion) {
        let currentUser = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: credential, completion: { (result, err) in
            if err != nil
            {
                ProgressHUD.showError(err?.localizedDescription)//(err?.localizedDescription)
                completion(err)
                return
            }
            currentUser?.updatePassword(to: newPassword, completion: { (err) in
                if err != nil
                {
                    ProgressHUD.showError("Failed to update  password")
                    return
                }
                ProgressHUD.showSuccess("Password Changed"); self.navigationController?.popViewController(animated: true)

            })
        })
        /*
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
            if error == nil {
                currentUser?.updatePassword(to: newPassword) { (errror) in
                    completion(errror)
                }
            } else {
                completion(error)
            }
        })*/
    }

}

