//
//  HomeFeedCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
import MediaPlayer
import Firebase
class HomeFeedCell: UICollectionViewCell {
    
    var post:AudioPost?{
        didSet{
            guard let post = post else {return}
            guard let url = URL(string: post.user.picture_path) else {return}
            let image = #imageLiteral(resourceName: "profile-imag")
           // print(url)
            profileImage.kf.setImage(with: url, placeholder: image)
            //set username and date
            let attributedText = NSMutableAttributedString(string: post.user.full_name, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)])
            
            attributedText.append(NSAttributedString(string: "\n\(post.creationDate.timeAgoDisplay())", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:UIColor.gray]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 2
            
            attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
            userNameTimeLabel.attributedText = attributedText
            let duration = post.audioDuration / 1000
            timeLabel.text = "00:\(Int(duration))"
            //set caption Label
            if post.audioNote != ""
            {
                postTitle.text = post.audioNote
            }
            if post.audioNote.getLanguage() == "ar"
            {
                postTitle.textAlignment = .right
            }
        }
    }
    let profileImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "profile-imag")
        return image
    }()
    
    let userNameTimeLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        return label
    }()
    let menuButton:UIButton = {
        let button = UIButton()
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    lazy var playButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_action_play"), for: .normal)
        button.tintColor = .orange
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(playEpisode), for: .touchUpInside)
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
    let likeButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "love"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    let commentButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    lazy var topStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImage,userNameTimeLabel])
        stack.distribution = .fill//Equally
        stack.spacing = 12
        return stack
    }()
    lazy var controlsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeButton,commentButton])
        stack.spacing = 40
        return stack
    }()
    let containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let postTitle:UILabel = {
        let title = UILabel()
        title.text = nil
        // title.text = "Hello How are \n you are you alright"
        title.font = UIFont.systemFont(ofSize: 17)
        title.numberOfLines = -1
        return title
    }()
    lazy var bottomStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [playButton,recordSlider,timeLabel])
        stack.spacing = 4
        return stack
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAudioSession()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews()
    {
        addSubview(containerView)
        containerView.addSubview(bottomStack)
        containerView.addSubview(controlsStack)
        containerView.addSubview(menuButton)
        backgroundColor = .lightGray
        containerView.anchorToView(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
        containerView.addSubview(topStackView)
        topStackView.anchorToView(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 0, right: 62), size: .init(width: 0, height: 50))
        profileImage.anchorToView(size: .init(width: 50, height: 0))
        menuButton.anchorToView(top: userNameTimeLabel.topAnchor, leading: nil, bottom: nil, trailing:containerView.trailingAnchor, padding: .init(top: -12, left: 5, bottom: 5, right: 5), size: .init(width: 40, height: 40))
        containerView.addSubview(postTitle)
        postTitle.anchorToView(top: topStackView.bottomAnchor, leading: topStackView.leadingAnchor, bottom: bottomStack.topAnchor, trailing: menuButton.trailingAnchor,padding: .init(top: 5, left: 0, bottom: 5, right: 0))
        bottomStack.anchorToView(top: postTitle.bottomAnchor, leading: postTitle.leadingAnchor, bottom: controlsStack.topAnchor, trailing: postTitle.trailingAnchor, padding: .init(top: 5, left: 0, bottom:0, right: 0), size: .init(width: 0, height: 40))
        controlsStack.anchorToView(top: bottomStack.bottomAnchor, leading: bottomStack.leadingAnchor, bottom: containerView.bottomAnchor, trailing:nil, padding: .init(top: 0, left: 20, bottom: 12, right: 0), size: .init(width: 120, height: 40))
        likeButton.anchorToView( size: .init(width: 40, height: 40))
        commentButton.anchorToView(size: .init(width: 40, height: 40))
        playButton.anchorToView(size:.init(width: 40, height: 0))
    }
    var player:AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = true
        return avPlayer
    }()
    fileprivate func setupAudioSession()
    {
        do
        {
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch
        {
            print("Error setting session")
        }
    }
    @objc func playEpisode()
    {
       // var player: AVAudioPlayer?
        guard let url = post?.audioURL else {return}
        let storageReference = Storage.storage().reference(forURL: url)
        let pathString = "SongsPath.mp3"
//        let storageReference = Storage.storage().reference().child(pathString)
        let fileUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let fileUrl = fileUrls.first?.appendingPathComponent(pathString) else {
            return
        }
        
        let downloadTask = storageReference.write(toFile: fileUrl)
        
        downloadTask.observe(.success) { _ in
            guard let testurl = URL(string: (self.post?.audioURL)!) else {return}
                let item = AVPlayerItem(url: testurl)
                self.player.replaceCurrentItem(with: item)
                self.player.play()
        }

    }
        /*let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("file_name.mp3")
        
        Storage.storage().reference(forURL: url).getData(maxSize: 10 * 1024 * 1024) { (data, err) in
            if let error = err {
                print(error)
            } else {
                if let d = data {
                    do {
//                        print(d)
//                        print(fileURL)
                        try d.write(to: fileURL)
//                        let item = AVPlayerItem(url: URL(string: "http://feeds.soundcloud.com/stream/396259545-brian-hong-voong-my-experiences-in-computer-science-vs-real-world.mp3")!)
                        let item = AVPlayerItem(url: fileURL)
                        self.player.replaceCurrentItem(with: item)
                        self.player.play()
                    } catch {
                        print(error)
                    }
                }
            }
        }*/
    
        /*if let testurl = post?.audioURL
        {
            print(testurl)
           /* let storageRef = Storage.storage().reference().child(post?.uid ?? "").child("AudioPosts").child(testurl)
            storageRef.downloadURL
            { (url, err) in
                if err != nil
                {
                    print(err)
                }
                print(url)
            }*/
        }
        
        
        if let url = post?.audioURL
        {
            let refStorage = Storage.storage().reference(forURL: url)
            refStorage.downloadURL { (url, err) in
                if err != nil
                {
                    print(err)
                    return
                }
                //print(url)
                //guard let actualURL = URL(string: url) else {return}
                let item = AVPlayerItem(url: url!)
                self.player.replaceCurrentItem(with: item)
                self.player.play()
            }
            
            //let testURL =
            //"http://feeds.soundcloud.com/stream/396259545-brian-hong-voong-my-experiences-in-computer-science-vs-real-world.mp3"
//                guard let actualURL = URL(string: url) else {return}
//                let item = AVPlayerItem(url: actualURL)
//                player.replaceCurrentItem(with: item)
//                player.play()
        }*/
}

