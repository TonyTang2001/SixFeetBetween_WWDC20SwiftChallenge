//
//  GameSuccessView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/13/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI
import AVFoundation

struct SuccessSignView: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("You Won")
                .fontWeight(.semibold)
                .font(.system(.title, design: .rounded))
        }
    }
}

struct SuccessRatingView: View {
    let starCount: Int
    @State var start: Bool = false
    
    func determineColor(index: Int) -> Color {
        if index <= starCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 * Double(index)) {
                AVAudioPlayer.playSound2(sound: "coin7", type: "wav")
            }
            return Color.yellow
        } else {
            return Color.gray
        }
    }
    
    func determineOpacity(index: Int) -> Double {
        if index <= starCount {
            return 1
        } else {
            return 0
        }
    }
    
    func determineAnimation(index: Int) -> Animation {
        return Animation.easeOut.delay(Double(index) * 0.3)
    }
    
    var body: some View {
        HStack {
            ForEach(1..<4, id: \.self) { i in
                ZStack {
                    Image(systemName: "star.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(self.determineColor(index: i))
                    
                    Image(systemName: "star.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .scaleEffect(self.start ? 1.8 : 1)
                        .opacity(self.start ? 0 : self.determineOpacity(index: i))
                        .foregroundColor(Color.yellow)
                        .animation(self.determineAnimation(index: i))
                }
                
                
            }
            
        }
        .onAppear {
            withAnimation {
                self.start = true
            }
        }
    }
}

public struct GameSuccessView: View {
    
    @State var appear = false
    @State var userDrag = CGSize.zero
    
    let gameDuration = getGameDuration(from: startTime, to: endTime)
    
    public init() {}
    
    let textOption = Int.random(in: 0..<5)
    let successSentences: [String] = ["You are a Hero!",
                                      "Lengendary!",
                                      "Congratulations!",
                                      "Good Job!",
                                      "Play of the Game!"]
    
    public var body: some View {
        VStack {
            Spacer()
            VStack {
                Spacer()
                SuccessSignView()
                
                Spacer()
                SuccessRatingView(starCount: getGameRating(duration: gameDuration))
                
                Spacer()
                Text(successSentences[textOption])
                    .fontWeight(.bold)
                    .font(.system(.largeTitle, design: .rounded))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .frame(width: 420, height: 330)
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: Color.black.opacity(0.3), radius: 22, x: 16, y: 16)
            .offset(x: 0, y: self.appear ? 0 : 16)
            .rotation3DEffect(Angle(degrees: Double(0.07 * getLength(x: userDrag.width, y: userDrag.height))), axis: (x: userDrag.width * 0.1, y: userDrag.height * 0.1, z: 0.0))
            .animation(.easeInOut)
            
            Spacer()
            
            Text("To restart the game, \ntap on Playground Start/Stop Button.")
                .fontWeight(.semibold)
                .font(.system(.footnote, design: .rounded))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .opacity(self.appear ? 1 : 0)
        .onAppear {
            withAnimation {
                self.appear = true
            }
            AVAudioPlayer.stopPlaySoundBG()
            AVAudioPlayer.playSound(sound: "success2", type: "wav")
        }
        .gesture(
            DragGesture().onChanged { value in
                self.userDrag = value.translation
            }
            .onEnded { value in
                self.userDrag = .zero
            }
        )
        
    }
}

struct GameSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        GameSuccessView()
    }
}

