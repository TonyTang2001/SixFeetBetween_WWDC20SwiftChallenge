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

extension AVAudioPlayer {

    static func playSound(sound: String, type: String) {
        guard let path = Bundle.main.path(forResource: sound, ofType: type) else {
            fatalError("Could not find path for audio file named: \(sound)")
        }
        do {
//            var audioPlayer: AVAudioPlayer?
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
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
            audioPlayer2?.play()
        } catch {
            print("Error: Could not play sound file")
        }
        
    }
    
    

    
}
