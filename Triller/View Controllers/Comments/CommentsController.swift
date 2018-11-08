//
//  CommentsController.swift
//  Triller
//
//  Created by Sherif  Wagih on 11/3/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import IQAudioRecorderController
import Firebase
import ProgressHUD
class CommentsController: UICollectionViewController,UICollectionViewDelegateFlowLayout,IQAudioRecorderViewControllerDelegate {
    
    func audioRecorderController(_ controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String) {
        dismiss(animated: true) {
            self.uploadAudio(filePath:filePath)
        }
    }
    
    private func uploadAudio(filePath:String)
    {
        guard let currentID = Auth.auth().currentUser?.uid else {return}
        guard let finalPath = URL(string: "file:///\(filePath)") else {return};
        let fileName = NSUUID().uuidString
        let uploadFileName = "Trill_Audio_\(fileName).m4a"
        let uploadFilePath = "\(currentID)/AudioPostComments/\(uploadFileName)"
        let storageRef = Storage.storage().reference(withPath: uploadFilePath)
        let metaData = StorageMetadata()
        metaData.contentType = "audio/m4a"
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
                guard let post = self.post else {return}
                let reference = Database.database().reference().child("Comments").child(post.audioKey).childByAutoId()
                
                let values = ["audioDuration":self.getAudioInSeconds(finalPath:  finalPath),"audioName":uploadFileName,"audioUri":urlValue                     ,"creationDate":Date().timeIntervalSince1970,"uid":currentID] as [String : Any]
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
    func getAudioInSeconds(finalPath:URL) -> Double
    {
        let audioAsset = AVURLAsset.init(url: finalPath, options: nil)
        let duration = audioAsset.duration
        let actualDuration = CMTimeGetSeconds(duration)
        let roundedDudration = Double(round(1000*actualDuration)/1000)
        return roundedDudration * 1000
    }
    
    func audioRecorderControllerDidCancel(_ controller: IQAudioRecorderViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var comments:[Comment]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var post:AudioPost?{
        didSet{
            guard let post = post else {return}
            getCommentsByPostID(post: post)
        }
    }
    enum CellName:String {
        case Header = "HeaderID"
        case Cell = "CellD"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupCollectionView()
        setupRecordingButton()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
    }
    
    lazy var recordingButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_action_mic").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(startRecordingComment), for: .touchUpInside)
        return button
    }()
    
    func setupRecordingButton()
    {
        self.view.addSubview(recordingButton)
        recordingButton.anchorToView(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), size:CGSize(width: 40, height: 40))
    }
    
    func setupCollectionView()
    {
        collectionView.register(CommentsHeader.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellName.Header.rawValue)
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CellName.Cell.rawValue)
        collectionView.backgroundColor = .lightGray
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellName.Header.rawValue, for: indexPath) as! CommentsHeader
        header.post = post
        header.backgroundColor = .white
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 260)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.post = comments?[indexPath.item]
        dummyCell.layoutIfNeeded()
        let estimatedsize = dummyCell.systemLayoutSizeFitting(CGSize(width: frame.width, height: 1000))
        let height = estimatedsize.height
        return CGSize(width: view.frame.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName.Cell.rawValue, for: indexPath) as! CommentCell
        cell.post = comments?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 260)
        let dummyCell = CommentsHeader(frame: frame)
        dummyCell.post = post
        dummyCell.layoutIfNeeded()
        let estimatedsize = dummyCell.systemLayoutSizeFitting(CGSize(width: frame.width, height: 1000))
        let height = estimatedsize.height
        return CGSize(width: view.frame.width, height: height)
    }
    func getCommentsByPostID(post:AudioPost)
    {
        FirebaseService.getCommentsByPostID(post: post) { (allComments) in
            self.comments = allComments
            self.collectionView.reloadData()
        }
    }
    @objc func startRecordingComment()
    {
        let audioController = AudioRecorderView(delegate_:self)
        audioController.PresentAudioRecorder(target: self)
    }
}
