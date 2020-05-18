//
//  GameFailureView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/13/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI
import AVFoundation

struct FailureSignView: View {
    var body: some View {
        HStack {
            Image(systemName: "xmark.seal.fill")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("You Lost")
                .fontWeight(.semibold)
                .font(.system(.title, design: .rounded))
        }
    }
}

struct FaliureThumbNailView: View {
    @State var animate: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .frame(width: 80, height: 14)
                .foregroundColor(Color.red)
                .rotationEffect(self.animate ? Angle(degrees: 45) : Angle(degrees: 0))
            
            
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .frame(width: 80, height: 14)
                .foregroundColor(Color.red)
                .rotationEffect(self.animate ? Angle(degrees: -45) : Angle(degrees: 0))
        }
        .frame(width: 60, height: 60)
        .animation(Animation.spring().delay(0.1))
        .onAppear {
            withAnimation {
                self.animate = true
            }
        }
        
    }
}

public struct GameFailureView: View {
    
    @State var appear = false
    @State var userDrag = CGSize.zero
    
    public init() {}
    
    let textOption = Int.random(in: 0..<6)
    let failureSentences: [String] = ["Good Work, \nbut Not Enough.",
                                      "Still a Way to Go",
                                      "Keep up with It, \nYou Got This!",
                                      "Just... a bit More.",
                                      "Better Luck Next Time!",
                                      "Oops, didn't see that coming..."]
    
    public var body: some View {
        VStack {
            Spacer()
            VStack {
                Spacer()
                FailureSignView()
                
                Spacer()
                FaliureThumbNailView()
                
                Spacer()
                Text(failureSentences[textOption])
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
            self.appear = true
            AVAudioPlayer.stopPlaySoundBG()
            AVAudioPlayer.playSound(sound: "error2", type: "wav")
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

struct GameFailureView_Previews: PreviewProvider {
    static var previews: some View {
        GameFailureView()
    }
}

