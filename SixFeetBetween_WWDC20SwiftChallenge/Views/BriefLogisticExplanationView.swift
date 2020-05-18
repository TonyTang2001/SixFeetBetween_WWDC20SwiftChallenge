//
//  BriefLogisticExplanationView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/17/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

public struct BriefLogisticExplanationView: View {
    
    @Binding var animate3Start: Bool
    @Binding var animate3End  : Bool
    @Binding var animate4Start: Bool
    @Binding var animate4End  : Bool
    @Binding var animate5Start: Bool
    
    public init(
        animate3Start: Binding<Bool>,
        animate3End: Binding<Bool>,
        animate4Start: Binding<Bool>,
        animate4End: Binding<Bool>,
        animate5Start: Binding<Bool>) {
        
        self._animate3Start = animate3Start
        self._animate3End   = animate3End
        self._animate4Start = animate4Start
        self._animate4End   = animate4End
        self._animate5Start = animate5Start
        
    }
    
    public var body: some View {
        VStack {
            Spacer()
            
            FactoryView()
                .frame(width: 100, height: 100)
                .opacity(animate3Start ? 1 : 0)
                .animation(Animation.easeInOut)
                .offset(y: self.animate5Start ? -1000 : 0)
            
            Image(uiImage: UIImage(named: "Ninja_Circle")!)
                .resizable()
                .frame(width: playerSize, height: playerSize)
                .opacity(animate4Start ? 1 : 0)
                .animation(Animation.easeInOut)
                .offset(y: animate4Start ? 0 : 20)
            
            Spacer()
            
            Image(systemName: "chevron.left.2")
                .resizable()
                .foregroundColor(playerPathColor)
                .rotationEffect(Angle(degrees: 90))
                .frame(width: playerSize, height: playerSize)
                .opacity((animate3Start && !animate4Start) ? 1 : 0)
                .animation(Animation.easeInOut)
                .offset(y: animate4Start ? -40 : 0)
            
            Image(uiImage: UIImage(named: "Ninja_Circle")!)
                .resizable()
                .frame(width: playerSize, height: playerSize)
                .opacity((animate3Start && !animate4Start) ? 1 : 0)
                .animation(Animation.easeInOut)
                .offset(y: animate4Start ? -60 : 0)
                
            LabView()
                .frame(width: 100, height: 100)
                .opacity(animate3Start ? 1 : 0)
                .animation(Animation.easeInOut)
                .offset(y: self.animate5Start ? 1000 : 0)
            
            Spacer()
            
            ButtonStackView2(animate3End: $animate3End, animate4Start: $animate4Start, animate4End: $animate4End, animate5Start: $animate5Start)
            
            Spacer()
        }
    }
}
