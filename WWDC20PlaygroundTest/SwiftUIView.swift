//
//  SwiftUIView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/11/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    @State var isAtMaxScale = false
    
    private let animation = Animation.easeInOut(duration: 0.1).repeatForever(autoreverses: true)
    private let maxScale: CGFloat = 2
    
    var body: some View {
        HStack {
            Spacer()
            
            Circle()
                .frame(width: 50, height: 50)
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.blue, lineWidth: 20)
                        
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(Color.black, lineWidth: 20)
                        
                    }
                    
                )
            
            Spacer()
            
            Circle()
                .frame(width: 50, height: 50)
                .padding(20)
                .border(Color.blue, width: 20)
            
            Spacer()
        }
        
    }
}

struct TestSeparateView: View {
    @Binding var isAtMaxScale: Bool
    
    var body: some View {
        
        VStack {
            Text("Animations")
                .opacity(isAtMaxScale ? 1 : 0)
                .animation(Animation.easeInOut.speed(0.01))
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
