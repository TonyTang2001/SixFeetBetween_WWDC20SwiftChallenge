//
//  MediaModule.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/16/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import Foundation
import AVFoundation

public var audioPlayer: AVAudioPlayer?
public var audioPlayer2: AVAudioPlayer?
public var audioPlayerBG: AVAudioPlayer?

extension AVAudioPlayer {
    
    static func playSound(sound: String, type: String) {
        guard let path = Bundle.main.path(forResource: sound, ofType: type) else {
            fatalError("Could not find path for audio file named: \(sound)")
        }
        do {
            //            var audioPlayer: AVAudioPlayer?
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.volume = 0.5
            audioPlayer?.play()
        } catch {
            print("Error: Could not play sound file")
        }
        
    }
    
    static func playSound2(sound: String, type: String) {
        guard let path = Bundle.main.path(forResource: sound, ofType: type) else {
            fatalError("Could not find path for audio file named: \(sound)")
        }
        do {
            audioPlayer2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer2?.volume = 0.1
            audioPlayer2?.play()
        } catch {
            print("Error: Could not play sound file")
        }
        
    }
    
    static func startPlaySoundBG() {
        guard let path = Bundle.main.path(forResource: "clock1", ofType: "wav") else {
            fatalError("Could not find background audio file")
        }
        do {
            audioPlayerBG = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayerBG?.rate = 4
            audioPlayerBG?.numberOfLoops = -1
            audioPlayerBG?.volume = 0.08
            audioPlayerBG?.play()
        } catch {
            print("Error: Could not play sound file")
        }
        
    }
    
    static func stopPlaySoundBG() {
        audioPlayerBG?.stop()
    }
    
    
}

