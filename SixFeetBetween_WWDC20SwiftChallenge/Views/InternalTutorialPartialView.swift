//
//  InternalTutorialPartialView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/17/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

public struct InternalTutorialPart1View: View {
    
    @Binding var animate1Start: Bool
    @Binding var animate1End  : Bool
    @Binding var animate2Start: Bool
    @Binding var animate2End  : Bool
    @Binding var animate3Start: Bool
    
    public init(
        animate1Start: Binding<Bool>,
        animate1End: Binding<Bool>,
        animate2Start: Binding<Bool>,
        animate2End: Binding<Bool>,
        animate3Start: Binding<Bool>) {
        self._animate1Start = animate1Start
        self._animate1End   = animate1End
        self._animate2Start = animate2Start
        self._animate2End   = animate2End
        self._animate3Start = animate3Start
        
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text("Your destination is the factory, \non the top of your screen.")
                .fontWeight(.semibold)
                .font(.system(.title, design: .rounded))
                .multilineTextAlignment(.center)
                .opacity((self.animate2Start && !self.animate2End) ? 1 : 0)
            
            Spacer()
            
            Button(action: {
                self.animate1End = true
                self.animate2End = true
                self.animate3Start = true
            }) {
                Text("Next")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
            }
            .opacity((animate2Start && !animate1End) ? 1 : 0)
            .animation(Animation.easeInOut)
            
            Spacer()
            
            Text("You will start off at the Lab, \non the bottom of your screen.")
                .fontWeight(.semibold)
                .font(.system(.title, design: .rounded))
                .multilineTextAlignment(.center)
                .opacity((self.animate1Start && !self.animate1End) ? 1 : 0)
            Spacer()
        }
    }
}

public struct InternalTutorialPart2View: View {
    
    @Binding var animate3Start: Bool
    @Binding var animate3End  : Bool
    @Binding var animate4Start: Bool
    
    public init(
        animate3Start: Binding<Bool>,
        animate3End: Binding<Bool>,
        animate4Start: Binding<Bool>) {
        
        self._animate3Start = animate3Start
        self._animate3End   = animate3End
        self._animate4Start = animate4Start
        
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text("There will be people walking around.\nBeware that you don't know about \ntheir health conditions, \nand most of them are infected.")
                .fontWeight(.semibold)
                .font(.system(.title, design: .rounded))
                .multilineTextAlignment(.center)
                .animation(Animation.easeInOut(duration: 0.8))
            
            HStack {
                NPCInternalView(isDragging: .constant(false))
                NPCInternalView(isDragging: .constant(false))
                NPCInternalView(isDragging: .constant(false))
            }
            .animation(Animation.easeInOut(duration: 0.8))
            
            Text("To protect yourself, \nkeep at lease 6 feet away from others!")
                .fontWeight(.semibold)
                .font(.system(.title, design: .rounded))
                .multilineTextAlignment(.center)
                .animation(Animation.easeInOut(duration: 0.8))
            
            Spacer()
            
            Button(action: {
                self.animate3End = true
                self.animate4Start = true
            }) {
                Text("Next")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
            }
            .animation(Animation.easeInOut)
            
            Spacer()
        }
    }
}

public struct InternalTutorialPart3View: View {
    
    @Binding var animate5End  : Bool
    @Binding var animate6Start: Bool
    
    public init(
        animate5End: Binding<Bool>,
        animate6Start: Binding<Bool>) {
        
        self._animate5End   = animate5End
        self._animate6Start = animate6Start
        
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text("When you are trying to blink, \nyou will freeze the time and see \nthe 6-feet safety distance around other people. \nPedestrians will freeze until you complete your \"Blink\"")
                .fontWeight(.semibold)
                .font(.system(.title, design: .rounded))
                .multilineTextAlignment(.center)
                .animation(Animation.easeInOut(duration: 0.8))
            
            Spacer()
            
            HStack {
                Spacer()
                NPCInternalView(isDragging: .constant(true))
                Spacer()
                NPCInternalView(isDragging: .constant(true))
                Spacer()
                NPCInternalView(isDragging: .constant(true))
                Spacer()
            }
            .animation(Animation.easeInOut(duration: 0.8))
            
            Spacer()
            
            Text("Remember, \nkeep at lease 6 feet away from others!")
                .fontWeight(.semibold)
                .font(.system(.title, design: .rounded))
                .multilineTextAlignment(.center)
                .animation(Animation.easeInOut(duration: 0.8))
            
            Spacer()
            
            Button(action: {
                self.animate5End = true
                self.animate6Start = true
            }) {
                Text("Next")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
            }
            .animation(Animation.easeInOut)
            
            Spacer()
        }
    }
}
