//
//  HomeFeedCell.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import MediaPlayer
import Firebase
import ProgressHUD

protocol tappedProfileOrNameLabelOrCommentsDelegateOrPlay
{
    func viewProfile(gesture:UITapGestureRecognizer)
    func viewComments(gesture:UITapGestureRecognizer)
}

class HomeFeedCell: UICollectionViewCell {
    var isHeader:Bool = false
    var delegate:tappedProfileOrNameLabelOrCommentsDelegateOrPlay?
    var post:MediaItem?{
        didSet{
            postDateLabel.text = post?.creationDate.timeAgoDisplay()
            if let url = URL(string: post?.user?.picture_path ?? "")
            {
                let image = #imageLiteral(resourceName: "profile-imag")
                profileImage.sd_setImage(with: url, completed: nil)
                //profileImage.kf.setImage(with: url, placeholder: image)
            }
            //set username and date
            userName.text = post?.user?.full_name
            let duration = post?.audioDuration ?? 0
            let formattedTime = String(format: "%02d", Int(duration  / 1000))
            self.timeLabel.text = "00:00 / 00:\(formattedTime)"
            guard let post = post as? AudioPost else {return}
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
    
    lazy var profileImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "profile-imag")
       image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewUserProfile)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var userName:UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewUserProfile)))
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let postDateLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var usernameTimeStack : UIStackView = {
       let stack = UIStackView(arrangedSubviews: [userName,postDateLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 0
        stack.alignment = .top
        return stack
    }()
    lazy var menuButton:UIButton = {
        let button = UIButton()
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.addTarget(self, action: #selector(handlePostMenu), for: .touchUpInside)
        return button
    }()
    
    lazy var playButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_action_play"), for: .normal)
        button.tintColor = .orange
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(playEpisode), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var recordSlider:UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .red
        slider.addTarget(self, action: #selector(handleVideoTimeSeekSlider), for: .valueChanged)
        slider.isEnabled = false
        slider.thumbTintColor = .gray
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
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    lazy var commentButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewComments)))
        return button
    }()
    lazy var topStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImage,usernameTimeStack])
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
    
    lazy var playAllButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_action_play").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Play All", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .white
        button.isEnabled = true
        return button
    }()
    
    let bottomSeparator:UIView = {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        return separator
    }()
    
    func setupViews()
    {
        backgroundColor = .lightGray
        addSubview(containerView)
        containerView.addSubview(topStackView)
        containerView.addSubview(menuButton)
        containerView.addSubview(postTitle)
        containerView.addSubview(bottomStack)
        containerView.addSubview(controlsStack)
        if isHeader
        {
          setupHeaderViews()
        }
        //setup contaner view
        containerView.anchorToView(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top:0,left:8,bottom:0,right:8))
        //setup Top Stack
        topStackView.anchorToView(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 0, right: 62), size: .init(width: 0, height: 50))
         profileImage.anchorToView(size: .init(width: 50, height: 0))
        //setup menu Button
          menuButton.anchorToView(top: usernameTimeStack.topAnchor, leading: nil, bottom: nil, trailing:containerView.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 5, right: 5), size: .init(width: 40, height: 40))
        
        //post Title
          postTitle.anchorToView(top: topStackView.bottomAnchor, leading: topStackView.leadingAnchor, bottom: bottomStack.topAnchor, trailing: menuButton.trailingAnchor,padding: .init(top: 5, left: 0, bottom: 5, right: 0))
        //setup bottom stack

       bottomStack.anchorToView(top: postTitle.bottomAnchor, leading: postTitle.leadingAnchor, bottom: controlsStack.topAnchor, trailing: postTitle.trailingAnchor, padding: .init(top: 5, left: 0, bottom:0, right: 0), size: .init(width: 0, height: 35))
        playButton.anchorToView(size:.init(width: 35, height: 35))

        //setup controls stack
        controlsStack.anchorToView(top: bottomStack.bottomAnchor, leading: bottomStack.leadingAnchor, bottom: isHeader ?bottomSeparator.topAnchor : bottomAnchor   , trailing:nil, padding: .init(top: 0, left: 20, bottom: 12, right: 20), size: .init(width: 100, height: 30))
        likeButton.anchorToView( size: .init(width: 30, height: 30))
        commentButton.anchorToView(size: .init(width: 30, height: 30))
    }
    
    func setupHeaderViews()
    {
        containerView.addSubview(bottomSeparator)
        containerView.addSubview(playAllButton)
        //bottom separator setup
        bottomSeparator.anchorToView(top: controlsStack.bottomAnchor, leading: leadingAnchor, bottom: playAllButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 2))
        //play all button
        playAllButton.anchorToView(top: bottomSeparator.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 40))

    }
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
    var firstTimePlayer = false
    @objc func playEpisode()
    {
        if !firstTimePlayer
        {
            downloadAndPlaySound()
        }
        else
        {
            let currentTime = CMTimeGetSeconds(player.currentTime())
            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            if currentTime == duration
            {
                player.seek(to: .zero)
                player.play()
                return
            }
            else
            {
                if player.timeControlStatus == .paused
                {
                    player.play()
                    playButton.setImage(#imageLiteral(resourceName: "ic_action_pause"), for: .normal)
                }
                else if player.timeControlStatus == .playing
                {
                    player.pause()
                    playButton.setImage(#imageLiteral(resourceName: "ic_action_play"), for: .normal)
                }
            }
            
        }
    }
    func downloadAndPlaySound()
    {
        ProgressHUD.show()
        //spinnerView?.alpha = 1
        firstTimePlayer = true
        guard let postURL = post?.audioURL else {return}
        guard let playURL = URL(string: postURL) else {return}
        CustomAvPlayer.shared.loadSoundUsingSoundURL(url: playURL) { (data) in
            if let data = data
            {
                guard var toPlayURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                toPlayURL.appendPathComponent("sound.m4a")
                do
                {
                    try data.write(to: toPlayURL)
                }
                catch
                {
                    
                }
                let item = AVPlayerItem(url: toPlayURL)
                self.player.replaceCurrentItem(with: item)
                self.player.play()
                self.recordSlider.isEnabled = true
                self.recordSlider.thumbTintColor = .red
            }
            else
            {
                ProgressHUD.showError("Failed to load sound")
            }
        }
    }
    //var spinnerView:SpinnerView?
    //MARK:- Player Observers
    fileprivate func playerObservers()
    {
        let time = CMTimeMake(value: 1,timescale: 3)
        let times = [NSValue(time:time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            self?.playButton.setImage(#imageLiteral(resourceName: "ic_action_pause"), for: .normal)
            ProgressHUD.dismiss()
        }
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {(time) in
            let duration = time.toDisplayString()
            guard let fullTime =  self.player.currentItem?.duration.toDisplayString() else {return}
            let realDuration = self.post!.audioDuration / 1000
            let formattedTime = String(format: "%02d", Int(realDuration))
            
            self.timeLabel.text = "\(duration) / 00:\(formattedTime)"
            self.updatePlayerSlider()
            if duration == fullTime && self.recordSlider.value == 1
            {
                self.playButton.setImage(#imageLiteral(resourceName: "ic_action_play"), for: .normal)
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
    
    @objc func handleVideoTimeSeekSlider()
    {
        if let duration = player.currentItem?.duration
        {
            let totalSeconds = duration.seconds
            let value = Float(recordSlider.value) * Float(totalSeconds)
            let cmTime = CMTime(value: CMTimeValue(value), timescale: 1)
            player.seek(to: cmTime, completionHandler: { (completed) in
                self.player.play()
            })
        }
    }
    
    @objc func handlePostMenu()
    {
        
    }
    
    func showEditShare()
    {
        
    }
    
    func showReportShare()
    {
        
    }
    @objc func viewUserProfile(gesture:UITapGestureRecognizer)
    {
        delegate?.viewProfile(gesture:gesture)
    }
    @objc func viewComments(gesture:UITapGestureRecognizer)
    {
        delegate?.viewComments(gesture: gesture)
    }
}
