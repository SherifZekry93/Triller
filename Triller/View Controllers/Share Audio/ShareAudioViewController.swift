//
//  ShareAudioViewController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/27/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import AVFoundation
import ProgressHUD
import Firebase
class ShareAudioViewController: UIViewController,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UITextViewDelegate {
    
    var filePath:String?
    
    let audioNoteTextField:UITextView = {
        let audioNote = UITextView()
        audioNote.layer.cornerRadius = 4
        audioNote.layer.borderColor = UIColor.lightGray.cgColor
        audioNote.layer.borderWidth = 1.2
        audioNote.text = "Placeholder"
        audioNote.textColor = UIColor.lightGray
        audioNote.font = UIFont.systemFont(ofSize: 16)
        return audioNote
    }()
    
    lazy var playButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_action_play"), for: .normal)
        button.tintColor = .orange
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(playRecorderVocie), for: .touchUpInside)
        return button
    }()
    
    let recordSlider:UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .red
        return slider
    }()
    
    let timeLabel:UILabel = {
        let label = UILabel()
        label.text = "00:00"
        return label
    }()
    
    lazy var playStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [playButton,recordSlider,timeLabel])
        stack.spacing = 4
        return stack
    }()
    
    var player:AVAudioPlayer = {
        let avPlayer = AVAudioPlayer()
        return avPlayer
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.textColor == UIColor.lightGray
        {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCustomNavigationBar()
        setupControls()
        setupAudioSession()
        audioNoteTextField.delegate = self
    }
    func setupCustomNavigationBar()
    {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissCurrentController))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(sharePostToFirebase))
        
    }
    func setupControls()
    {
        self.view.addSubview(audioNoteTextField)
        audioNoteTextField.anchorToView(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 12, right: 12), size: .init(width: 0, height: 150))
        self.view.addSubview(playStack)
        playStack.anchorToView(top: audioNoteTextField.bottomAnchor, leading: audioNoteTextField.leadingAnchor, bottom: nil, trailing: audioNoteTextField.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 30), centerH: false, centerV: false)
        playButton.anchorToView(size: .init(width: 30, height: 0))
    }
    private func uploadAudio(){
        guard let currentID = Auth.auth().currentUser?.uid else {return}
        guard let Path = filePath else {return
        }
        guard let finalPath = URL(string: "file:///\(Path)") else {return};
        print(finalPath)
        let fileName = NSUUID().uuidString
        let uploadFileName = "Trill_Audio_\(fileName).m4a"
        let uploadFilePath = "\(currentID)/AudioPosts/\(uploadFileName)"
        let storageRef = Storage.storage().reference(withPath: uploadFilePath)
        let metaData = StorageMetadata()
        metaData.contentType = "audio/m4a"
        //let movUrl = URL(string: desc)
        let task = storageRef.putFile(from: finalPath, metadata: metaData, completion: {
            meta, error in
            if error != nil{
                print("Error uploading File")
                return
            }
            storageRef.downloadURL(completion: { (url, err) in
                if err != nil
                {
                    ProgressHUD.showError(err?.localizedDescription)
                    return
                }
                guard let urlValue = url?.absoluteString else {return}
                let reference = Database.database().reference().child("AudioPosts").childByAutoId()
                let values = ["audioDuration":self.getAudioInSeconds(finalPath:  finalPath),"audioName":uploadFileName,"audioNote":self.audioNoteTextField.text ?? "","audioUri":urlValue                     ,"creationDate":Date().timeIntervalSince1970,"uid":currentID] as [String : Any]
                reference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil
                    {
                        ProgressHUD.showError(err?.localizedDescription)
                        return
                    }
                    print("Uploaded successfully")
                    self.dismiss(animated: true, completion: nil)
                })
            })
            //let values = []
            //reference.updateChildValues(<#T##values: [AnyHashable : Any]##[AnyHashable : Any]#>, withCompletionBlock: <#T##(Error?, DatabaseReference) -> Void#>)
        })
        
        task.observe(.success, handler: {
         snap in
         switch snap.status{
         case .success:
         print("File Uploaded")
            ProgressHUD.dismiss()
         case .failure:
         print("Failed")
         default:
         print("default")
         }
         })
        task.observe(.progress, handler: {
         snap in
            ProgressHUD.show("Posting")
        })
    }
    @objc func dismissCurrentController()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sharePostToFirebase()
    {
        uploadAudio()
    }
    func getAudioInSeconds(finalPath:URL) -> Double
    {
        let audioAsset = AVURLAsset.init(url: finalPath, options: nil)
        let duration = audioAsset.duration
        let actualDuration = CMTimeGetSeconds(duration)
        let roundedDudration = Double(round(1000*actualDuration)/1000)
        return roundedDudration * 1000
    }
    @objc func playRecorderVocie()
    {
        guard let Path = filePath else {return
        }
        guard let finalPath = URL(string: "file:///\(Path)") else {return};
        do
        {
        self.player = try AVAudioPlayer(contentsOf: finalPath)
        self.player.prepareToPlay()
        self.player.volume = 1
        self.player.play()
        }
        catch
        {
            print("error playing audio")
        }
    }
    fileprivate func setupAudioSession()
    {
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch
        {
            print("Error setting session")
        }
    }
}



