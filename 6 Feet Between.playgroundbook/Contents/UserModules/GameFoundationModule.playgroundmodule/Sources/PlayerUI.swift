//
//  PlayerUI.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/15/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

// MARK: - Player
struct MovePathIndicatorView: View {
    @Binding var showPathPreview: Bool
    @State var destCoord: CGSize
    
    var body: some View {
        Image(systemName: "xmark.circle")
            .resizable()
            .frame(width: playerSize, height: playerSize)
            .offset(destCoord)
            .foregroundColor(Color.blue.opacity(showPathPreview ? 1 : 0))
            .font(.system(size: 25, weight: .bold))
    }
}

public struct PlayerView: View {
    
    @Binding var inputX: CGFloat
    @Binding var inputY: CGFloat
    @Binding var showPathPreview: Bool
    @Binding var gameEnded: Bool
    
    @State var playerFailed = false
    @State var invalidMoveCount: Int = 0
    
    var tutorialMode: Bool
    
    public init(inputX: Binding<CGFloat>, inputY: Binding<CGFloat>, showPathPreview: Binding<Bool>, gameEnded: Binding<Bool>, tutorialMode: Bool) {
        self._inputX = inputX
        self._inputY = inputY
        self._showPathPreview = showPathPreview
        self._gameEnded = gameEnded
        self.tutorialMode = tutorialMode
    }
    
    
    public var body: some View {
        
        ZStack {
            
            // path preview
            Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: playerSize, height: playerSize)
                .offset(destinationPreviewCalculation(inputX: inputX, inputY: inputY))
                .foregroundColor(playerPathColor.opacity(showPathPreview ? 1 : 0))
                .font(.system(size: 25, weight: .bold))
            
            // player icon
            Image(uiImage: UIImage(named: "Ninja_Circle")!)
                .resizable()
                .frame(width: playerSize, height: playerSize)
                //                .foregroundColor(playerColor)
                // invalid move warning indication
                .modifier(Shake(animatableData: CGFloat(invalidMoveCount)))
                // movement animation
                .animation(.playerMove)
                .overlay(
                    Circle()
                        .foregroundColor(Color(UIColor.systemRed))
                        .frame(width: playerSize, height: playerSize)
                        .opacity((!self.tutorialMode && self.playerFailed) ? 0.9 : 0)
                    .animation(.easeInOut)
            )
            
        }
        .offset(showPathPreview ? newPosition : playerMove())
        
    }
    
    private func playerMove() -> CGSize {
        
        if tutorialMode {
            let jump = destinationPreviewCalculation(inputX: inputX, inputY: inputY)
            
            currentPosition = CGSize(width: jump.width + newPosition.width, height: jump.height + newPosition.height)
            
            AVAudioPlayer.playSound(sound: "jump", type: "wav")
            previousPosition = ScreenCoordinate(x: newPosition.width + viewWidth/2 , y: newPosition.height + viewHeight - playerSize/2)
            newPosition = currentPosition
            
            return newPosition
        }
        
        if endOnHold {
            return newPosition
        }
        
        let jump = destinationPreviewCalculation(inputX: inputX, inputY: inputY)
        
        currentPosition = CGSize(width: jump.width + newPosition.width, height: jump.height + newPosition.height)
        
        if playerOutOfView() {
            return newPosition
            // use async to prevent updating state variable during UI rerendering
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // trigger shaking animation to indicate invalid move warning
                withAnimation(.default) {
                    AVAudioPlayer.playSound(sound: "error1", type: "wav")
                    self.invalidMoveCount += 1
                    self.showPathPreview = true
                }
            }
            
        } else {
            // valid move
            AVAudioPlayer.playSound(sound: "jump", type: "wav")
            previousPosition = ScreenCoordinate(x: newPosition.width + viewWidth/2 , y: newPosition.height + viewHeight - playerSize/2)
            newPosition = currentPosition
        }
        
        if started {
            let gameStatus = gameStateCheck()
            if gameStatus.ended {
                // game ended
                endOnHold = true
                endTime = Date()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.gameEnded = true
                }
                
                if gameStatus.succeeded {
                    // player won
                    playerWon = true
                } else {
                    // player failed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.playerFailed = true
                    }
                    
                    playerWon = false
                    
                }
            } else {
                // game still going on
            }
        }
        
        started = true
        
        return newPosition
    }
    
    private func destinationPreviewCalculation(inputX: CGFloat, inputY: CGFloat) -> CGSize {
        let vectorDirectoin = CGSize(width: -inputX, height: -inputY)
        
        var vX = vectorDirectoin.width
        var vY = vectorDirectoin.height
        
        let const: CGFloat = 10
        
        if vX <= 0 {
            vX = -calculateMoveEstimate(input: -vX) * const
        } else {
            vX = calculateMoveEstimate(input: vX) * const
        }
        
        if vY <= 0 {
            vY = -calculateMoveEstimate(input: -vY) * const
        } else {
            vY = calculateMoveEstimate(input: vY) * const
        }
        
        let result = CGSize(width: vX, height: vY)
        
        return result
    }
    
}
