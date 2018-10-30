//
//  AudioRecorder.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/27/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import IQAudioRecorderController
class AudioRecorderView{
    
    var delegate:IQAudioRecorderViewControllerDelegate
    init(delegate_ : IQAudioRecorderViewControllerDelegate ) {
        self.delegate = delegate_
    }
    
    func PresentAudioRecorder(target:UIViewController)
    {
        let controller = IQAudioRecorderViewController()
        controller.delegate = delegate
        controller.maximumRecordDuration = 30
        controller.allowCropping = true
        controller.view.backgroundColor = .white
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        target.presentBlurredAudioRecorderViewControllerAnimated(controller)
    }
}
