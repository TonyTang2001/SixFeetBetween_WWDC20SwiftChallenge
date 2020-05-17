//
//  BackgroundView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/15/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

public struct BackgroundView: View {
    
    @State var animateStart: Bool = false
    
    @Binding var canvasWidth: CGFloat
    @Binding var canvasHeight: CGFloat
    
    public init(canvasWidth: Binding<CGFloat>, canvasHeight: Binding<CGFloat>) {
        self._canvasWidth = canvasWidth
        self._canvasHeight = canvasHeight
    }
    
    var totalShapeCount = 21
    let colors = [UIColor.systemRed, UIColor.systemYellow, UIColor.systemBlue, UIColor.systemPink, UIColor.systemTeal, UIColor.systemGray2, UIColor.systemIndigo, UIColor.systemOrange, UIColor.systemGreen, UIColor.systemPink]
    
    
    
    public var body: some View {
        ZStack {
            ForEach(0..<totalShapeCount) {_ in
                Circle()
                    .foregroundColor(Color(self.colors.randomElement()!))
                    .frame(width: CGFloat.random(in: self.canvasWidth/2...self.canvasWidth), height: CGFloat.random(in: self.canvasWidth/2...self.canvasWidth))
                    .offset(x: CGFloat.random(in: -self.canvasWidth...self.canvasWidth), y: CGFloat.random(in: -self.canvasHeight...self.canvasHeight))
            }
        }
        .opacity(0.05)
        .blur(radius: 50)
        .onAppear {
            self.animateStart = true
        }
        
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        
        BackgroundView(canvasWidth: .constant(500), canvasHeight: .constant(600))
    }
}
