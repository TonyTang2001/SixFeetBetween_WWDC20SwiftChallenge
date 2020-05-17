//
//  StoryView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/16/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

public struct StoryView: View {
    
    var endingString = "Go to the next page for some training!"
    
    @State var animate1Start = false
    @State var animate1End = false
    @State var animate2Start = false
    @State var animate2End = false
    @State var animate3Start = false
    @State var animate3End = false
    @State var animate4Start = false
    @State var animate4End = false
    @State var animate5Start = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            
            StoryTextIntroView(animate1Start: $animate1Start, animate1End: $animate1End, animate2Start: $animate2Start, animate2End: $animate2End, animate3Start: $animate3Start, animate3End: $animate3End)
            .opacity(animate3Start ? 0 : 1)
            .onAppear {
                self.animate1Start = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                    self.animate1End = true
                }
            }
            
            BriefLogisticExplanationView(animate3Start: $animate3Start, animate3End: $animate3End, animate4Start: $animate4Start, animate4End: $animate4End, animate5Start: $animate5Start)
            .opacity(animate5Start ? 0 : 1)
            
            VStack {
                Text(endingString)
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity(self.animate5Start ? 1 : 0)
                    .offset(y: self.animate5Start ? 0 : 16)
                    .animation(Animation.easeInOut(duration: 1))
            }
            .opacity(animate5Start ? 1 : 0)
            
        }
        
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
