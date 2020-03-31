//
//  ViewController.swift
//  AgoraSample
//
//  Created by Fumiya Tanaka on 2020/03/31.
//  Copyright © 2020 Funbase. All rights reserved.
//

import UIKit
import AgoraRtcKit

let channelId: Int = 1

class ViewController: UIViewController {
    
    lazy var engine = AgoraRtcEngineKit.sharedEngine(withAppId: "", delegate: self)
    var isJoiningChannel: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine.setAudioProfile(.default, scenario: .gameStreaming)
    }
    
    @IBAction private func didTapCallButton() {
        let joinResult = engine.joinChannel(byToken: nil, channelId: String(channelId), info: nil, uid: 0, joinSuccess: nil)
        if joinResult == 0 {
            engine.enableAudio()
            isJoiningChannel = true
        }
    }
    
    @IBAction private func didTapLeaveButton() {
        let leaveResult = engine.leaveChannel(nil)
        if leaveResult == 0 {
            isJoiningChannel = false
        }
    }
}

extension ViewController: AgoraRtcEngineDelegate {
}
