//
//  GameSuccessView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/13/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

struct SuccessSignView: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("Score: 999")
                .fontWeight(.semibold)
                .font(.system(.title, design: .rounded))
        }
    }
}

struct SuccessRatingView: View {
    let starCount = 2
    @State var start: Bool = false
    
    func determineColor(index: Int) -> Color {
        if index <= starCount {
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

struct GameSuccessView: View {
    let finalScore = 983
    let successSentences: [String] = ["You are a Hero!",
                                      "Lengendary!",
                                      "Congratulations!",
                                      "Good Job!",
                                      "Play of the Game!"]
    
    var body: some View {
        VStack {
            SuccessSignView()
            
            SuccessRatingView()
            
            Text(successSentences.randomElement()!)
                .fontWeight(.bold)
                .font(.system(.largeTitle, design: .rounded))
        }
        
    }
}

struct GameSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        GameSuccessView()
    }
}
