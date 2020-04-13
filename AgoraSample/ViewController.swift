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
    
    lazy var engine = AgoraRtcEngineKit.sharedEngine(withAppId: AGORA_APP_ID, delegate: self)
    
    var isAudioMuting: Bool = true
    var currentProfile: AgoraAudioProfile = .default {
        didSet {
            engine.leaveChannel { [unowned self] stats in
                self.engine.setAudioProfile(self.currentProfile, scenario: self.currentScenario)
            }
            self.startCall()
        }
    }
    
    var currentScenario: AgoraAudioScenario = .default {
        didSet {
            engine.leaveChannel { [unowned self] stats in
                self.engine.setAudioProfile(self.currentProfile, scenario: self.currentScenario)
                self.startCall()
            }
        }
    }
    
    private let scenarios: [AgoraAudioScenario] = [
        .default,
        .chatRoomEntertainment,
        .chatRoomGaming,
        .gameStreaming
    ]
    
    private let profiles: [AgoraAudioProfile] = [
        .default,
        .musicHighQuality,
        .musicHighQualityStereo,
        .musicStandard,
        .musicStandardStereo,
        .speechStandard
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        engine.setAudioProfile(currentProfile, scenario: currentScenario)
    }
    
    private func startCall() {
        let joinResult = engine.joinChannel(byToken: nil, channelId: String(channelId), info: nil, uid: 0, joinSuccess: nil)
        if joinResult == 0 {
            engine.enableAudio()
            engine.muteLocalAudioStream(isAudioMuting)
            print("Scenario: \(currentScenario.rawValue)")
            print("Profile: \(currentProfile.rawValue)")
        }
    }
    
    @IBAction private func didTapCallButton() {
        startCall()
    }
    
    @IBAction private func didTapLeaveButton() {
        _ = engine.leaveChannel(nil)        
    }
    
    @IBAction private func didChangeAudioMuteSwitch(_ sender: UISwitch) {
        isAudioMuting.toggle()
        engine.muteLocalAudioStream(isAudioMuting)
    }
    
    @IBAction private func didChangeVolumeSlider(_ sender: UISlider) {
        engine.adjustRecordingSignalVolume(Int(sender.value))
    }
    
    @IBAction private func didTapSelectProfileButton(_ sender: UIButton) {
        let tag = sender.tag
        currentProfile = profiles[tag]
    }
    
    @IBAction private func didTapSelectScenarioButton(_ sender: UIButton) {
        let tag = sender.tag
        currentScenario = scenarios[tag]
    }
}

extension ViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        engine.muteLocalAudioStream(isAudioMuting)
        engine.adjustRecordingSignalVolume(400)
    }
}
