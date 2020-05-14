//
//  GameFailureView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/13/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

struct FailureSignView: View {
    var body: some View {
        HStack {
            Image(systemName: "xmark.seal.fill")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("Failed")
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
        .animation(Animation.spring().delay(1))
        .onAppear {
            withAnimation {
                self.animate = true
            }
        }
        
    }
}

struct GameFailureView: View {
    let failureSentences: [String] = ["Good Work, but Not Enough",
                                      "Still a Way to Go",
                                      "Keep up with It, You Got This",
                                      "Just...a bit More",
                                      "There's Always another chance"]
    
    var body: some View {
        VStack {
            
            FailureSignView()
            
            FaliureThumbNailView()
            
            Text(failureSentences.randomElement()!)
                .fontWeight(.bold)
                .font(.system(.largeTitle, design: .rounded))
        }
    
        
    }
}

struct GameFailureView_Previews: PreviewProvider {
    static var previews: some View {
        GameFailureView()
    }
}
