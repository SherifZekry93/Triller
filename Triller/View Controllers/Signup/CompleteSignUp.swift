//
//  CompleteSignUp.swift
//  Triller
//
//  Created by Sherif  Wagih on 11/10/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import ProgressHUD
import Firebase
class CompleteSignUp: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    var imageWasChanged = false
    
    let backGroundImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "background")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var profilePicture:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "account")
        image.contentMode = .scaleAspectFill//Fit
        image.layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPhotoSelector)))
        image.layer.cornerRadius = 60
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        return image
    }()
    
    let changeProfileLabel:UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Add Your Picture", comment: "") 
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.textColor = .white
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
        text.customLabelPlaceHolder.text = NSLocalizedString("Full Name", comment: "")
        text.rightView = nil
        return text
    }()
    
    let statusText:CustomTextField = {
        let status = CustomTextField()
        status.textIcon.image = UIImage(named: "icons8-edit-file-50")
        status.customLabelPlaceHolder.text = NSLocalizedString("Status", comment: "")
        status.rightView = nil
        return status
    }()
    
    lazy var infoStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statusText,fullNameText])
        stack.axis = .vertical
        stack.spacing = 37.5
        stack.distribution = .fillEqually
        return stack
    }()
    
    let nextButton:UIButton = {
        let next = UIButton()
        next.backgroundColor = .white
        next.setTitle("Next", for: .normal)
        next.setTitleColor(.black, for: .normal)
        next.layer.cornerRadius = 20
        next.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        next.addTarget(self, action: #selector(handleAddingData), for: .touchUpInside)
        return next
    }()
    let skipButton:UIButton = {
        let next = UIButton()
        next.setTitle("Skip", for: .normal)
        next.setTitleColor(.white, for: .normal)
        next.layer.cornerRadius = 20
        next.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        next.addTarget(self, action: #selector(handleEscape), for: .touchUpInside)
        return next
    }()
    lazy var buttonsStack:UIStackView = {
       let stack = UIStackView(arrangedSubviews: [nextButton,skipButton])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    @objc func openPhotoSelector()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            ProgressHUD.show()
            self.openCamera()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            ProgressHUD.show()
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    lazy var imagePickerController:UIImagePickerController = {
        let profileImagePicker = UIImagePickerController()
        profileImagePicker.delegate = self
        profileImagePicker.allowsEditing = true
        return profileImagePicker
    }()
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            ProgressHUD.dismiss()
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        }
        else
        {
            
            ProgressHUD.dismiss()
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            ProgressHUD.dismiss()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        else
        {
            ProgressHUD.dismiss()
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    let scrollView:UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    var user:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchUserUsingUid()
        
    }
    
    func fetchUserUsingUid()
    {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseService.fetchUserByuid(uid: uid) { (user) in
            self.user = user
        }
    }
    
    func setupViews()
    {
        view.backgroundColor = .white
        view.addSubview(backGroundImage)
        backGroundImage.anchorToView(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        view.addSubview(scrollView)
        scrollView.anchorToView(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.addSubview(imageContainerStack)
        imageContainerStack.anchorToView(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width:0,height:150))
        profilePicture.anchorToView(size:.init(width: 120, height: 120))
        imageContainerStack.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        scrollView.addSubview(infoStack)
        infoStack.anchorToView(top: imageContainerStack.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 45, left: 20, bottom: 65, right: 20), size: .init(width: 0, height: 70 + (37.5)))
        scrollView.addSubview(buttonsStack)
        buttonsStack.anchorToView(top: infoStack.bottomAnchor, leading: infoStack.leadingAnchor, bottom: nil, trailing: infoStack.trailingAnchor, padding: .init(top: 37.5, left: 0, bottom: 0, right: 0))
    }
    @objc func handleAddingData()
    {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        if imageWasChanged
        {
            let imageName = "profile-image.png"
            let uploadFilePath = "\(currentUserID)/UserImege/\(imageName)"
            let storageRef = Storage.storage().reference(withPath:uploadFilePath)
            guard let image = self.profilePicture.image else {return}
            guard let uploadData = image.jpegData(compressionQuality: 0.25) else {return}
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
                    guard let url = url else {return}
                    self.uploadNewUserInfo(url: url.absoluteString)
                })
            }
        }
            
        else
        {
            guard let user = self.user else {return}
            let picturePath = user.picture_path
            uploadNewUserInfo(url: picturePath)
        }
        
    }
    func uploadNewUserInfo(url:String)
    {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        guard let currentAppLanguage = NSLocale.current.languageCode else {return}
        guard let user = self.user else {return}
        //let gender = self.genderTextField.text ?? ""
        let fullName = self.fullNameText.text ?? ""
        let status = self.statusText.text ?? ""
        let privateData = ["birth_date":user.private_data.birth_date.millisecondsSince1970,"gender":"","language":currentAppLanguage,"phone_number":user.private_data.phone_number,"register_date":user.private_data.register_date.millisecondsSince1970] as [String : Any]
        let allValues = ["email":user.email,"full_name":fullName,"full_phone":user.full_phone,"location":"","phone":user.phone,"phone_country":user.phone_country,"picture":"profile-image.png","picture_path":url,"private_data":privateData,"profile_is_private":false,"status":status,"uid":currentUserID,"user_name":user.user_name,"user_token":Messaging.messaging().fcmToken ?? ""] as [String : Any]
        
        let toUpdateValues = [currentUserID:allValues]; Database.database().reference().child("Users").updateChildValues(toUpdateValues, withCompletionBlock: { (err, ref) in
            if err != nil
            {
                ProgressHUD.showError(err?.localizedDescription)
                return
            }
            else
            {
                self.handleEscape()
            }
        })
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageWasChanged = true
        if let editedImage = info[.editedImage] as? UIImage
        {
            profilePicture.image = editedImage.withRenderingMode(.alwaysOriginal)
        }
        else if let originalImage = info[.originalImage] as? UIImage
        {
            profilePicture.image = originalImage.withRenderingMode(.alwaysOriginal)
        }
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderColor = UIColor(white: 0.98, alpha: 1).cgColor
        profilePicture.layer.borderWidth = 2
        dismiss(animated: true, completion: nil)
    }
    @objc func handleEscape()
    {
        let tabbar = MainTabBarController()
        self.navigationController?.pushViewController(tabbar, animated: true)
    }
}
