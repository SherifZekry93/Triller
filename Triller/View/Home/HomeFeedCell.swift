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
import ProgressHUD

class HomeFeedCell: UICollectionViewCell {
    var post:AudioPost?{
        didSet{
            guard let post = post else {return}
            if let url = URL(string: post.user.picture_path)
            {
                let image = #imageLiteral(resourceName: "profile-imag")
                profileImage.kf.setImage(with: url, placeholder: image)
            }
            //set username and date
            let attributedText = NSMutableAttributedString(string: post.user.full_name, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)])
            
            attributedText.append(NSAttributedString(string: "\n\(post.creationDate.timeAgoDisplay())", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:UIColor.gray]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 2
            
            attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
            userNameTimeLabel.attributedText = attributedText
          
            //timeLabel.text = "00:\(Int(duration))"
            //set caption Label
            if post.audioNote != ""
            {
                postTitle.text = post.audioNote
            }
            if post.audioNote.getLanguage() == "ar"
            {
                postTitle.textAlignment = .right
            }
            let duration = post.audioDuration / 1000
            let formattedTime = String(format: "%02d", Int(duration))
            self.timeLabel.text = "00:00 / 00:\(formattedTime)"//String(format: "00:%02d", post.audioDuration)
            
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
        button.imageView?.contentMode = .scaleAspectFill
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
        playerObservers()
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
        bottomStack.anchorToView(top: postTitle.bottomAnchor, leading: postTitle.leadingAnchor, bottom: controlsStack.topAnchor, trailing: postTitle.trailingAnchor, padding: .init(top: 5, left: 0, bottom:0, right: 0), size: .init(width: 0, height: 35))
        playButton.anchorToView(size:.init(width: 35, height: 0))
        controlsStack.anchorToView(top: bottomStack.bottomAnchor, leading: bottomStack.leadingAnchor, bottom: containerView.bottomAnchor, trailing:nil, padding: .init(top: 0, left: 20, bottom: 12, right: 0), size: .init(width: 120, height: 30))
        likeButton.anchorToView( size: .init(width: 40, height: 40))
        commentButton.anchorToView(size: .init(width: 40, height: 40))
        playButton.anchorToView(size:.init(width: 40, height: 0))
    }
   
   /* var player:AVAudioPlayer = {
        let avPlayer = AVAudioPlayer()
        // avPlayer.automaticallyWaitsToMinimizeStalling = true
        return avPlayer
    }()*/
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
    let player:AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    @objc func playEpisode()
    {
        guard let postURL = post?.audioURL else {return}
        guard let playURL = URL(string: postURL) else {return}
        CustomAvPlayer.shared.loadSoundUsingSoundURL(url: playURL) { (data) in
            if let data = data
            {
                
                guard var toPlayURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                toPlayURL.appendPathComponent("sound.m4a") // or whatever extension the video is
                do
                {
                    try data.write(to: toPlayURL) // assuming video is of Data type
                }
                catch
                {
                    
                }
                let item = AVPlayerItem(url: toPlayURL)
                self.player.replaceCurrentItem(with: item)
                self.player.play()
            }
            else
            {
                ProgressHUD.showError("Failed to load sound")
            }
        }
    }
    //MARK:- Player Observers
    fileprivate func playerObservers()
    {
        //enableDisableControls(enable: false)
        let time = CMTimeMake(value: 1,timescale: 3)
        let times = [NSValue(time:time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            self?.playButton.setImage(#imageLiteral(resourceName: "ic_action_pause"), for: .normal)
            //self?.enableDisableControls(enable: true)
            //self?.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            //self?.miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            //self?.modifyImageView(1)
        }
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {(time) in
            let duration = time.toDisplayString()
//            guard let currentDuration = self.post?.audioDuration else {
//                return}
            guard let fullTime =  self.player.currentItem?.duration.toDisplayString() else {return}
            
//            let realAudioDuration = currentDuration / 1000
            self.timeLabel.text = "\(duration) / \(fullTime)"
            //self.timeLabel.text = "\(duration):\(round(realAudioDuration))"
            self.updatePlayerSlider()
            if duration == fullTime
            {
                self.playButton.setImage(#imageLiteral(resourceName: "ic_action_play"), for: .normal)
                self.recordSlider.value = 0
            }
        }
    }
    func updatePlayerSlider()
    {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTime / duration
        recordSlider.value = Float(percentage)
    }
    func enableDisableControls(enable:Bool)
    {
        if enable
        {
            //finished loading
            //activityIndicator.stopAnimating()
        }
        else
        {
           // self.activityIndicator.startAnimating()
        }
        
        //playPauseButton.isEnabled = enable
        
        //playerSlider.isEnabled = enable
        
        //fastforward15Button.isEnabled = enable
        
        //rewind15Button.isEnabled = enable
        
        //miniPlayerPlayPauseButton.isEnabled = enable
        //miniPlayerFastforward15Button.isEnabled = enable
        
    }
}
