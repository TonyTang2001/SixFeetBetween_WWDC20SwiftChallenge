//
//  ButtonStackView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/17/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

public struct ButtonStackView1: View {
    
    @Binding var animate1Start: Bool
    @Binding var animate1End  : Bool
    @Binding var animate2Start: Bool
    @Binding var animate2End  : Bool
    @Binding var animate3Start: Bool
    @Binding var animate3End  : Bool
    
    public init(
        animate1Start: Binding<Bool>,
        animate1End: Binding<Bool>,
        animate2Start: Binding<Bool>,
        animate2End: Binding<Bool>,
        animate3Start: Binding<Bool>,
        animate3End: Binding<Bool>) {
        self._animate1Start = animate1Start
        self._animate1End   = animate1End
        self._animate2Start = animate2Start
        self._animate2End   = animate2End
        self._animate3Start = animate3Start
        self._animate3End   = animate3End
        
    }
    
    public var body: some View {
        ZStack {
            Button(action: {
                self.animate2Start = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.animate2End = true
                }
            }) {
                Text("Next")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
            }
            .opacity((animate1End && !animate2Start) ? 1 : 0)
            
            Button(action: {
                self.animate3Start = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.animate3End = true
                }
            }) {
                Text("Next")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
            }
            .opacity((animate2End && !animate3Start) ? 1 : 0)
        }
    }
}

public struct ButtonStackView2: View {
    
    @Binding var animate3End  : Bool
    @Binding var animate4Start: Bool
    @Binding var animate4End  : Bool
    @Binding var animate5Start: Bool
    
    public init(
        animate3End: Binding<Bool>,
        animate4Start: Binding<Bool>,
        animate4End: Binding<Bool>,
        animate5Start: Binding<Bool>) {
        
        self._animate3End   = animate3End
        self._animate4Start = animate4Start
        self._animate4End   = animate4End
        self._animate5Start = animate5Start
        
    }
    
    public var body: some View {
        ZStack {
            Button(action: {
                self.animate4Start = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.animate4End = true
                }
            }) {
                Text("Next")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
            }
            .opacity((animate3End && !animate4Start) ? 1 : 0)
            
            Button(action: {
                self.animate5Start = true
            }) {
                Text("Next")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
            }
            .opacity((animate4End && !animate5Start) ? 1 : 0)
        }
    }
}
