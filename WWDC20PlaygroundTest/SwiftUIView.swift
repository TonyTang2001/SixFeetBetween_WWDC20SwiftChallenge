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
        TestSeparateView(isAtMaxScale: $isAtMaxScale)
            .font(.largeTitle)
            .offset(x: isAtMaxScale ? 100 : 0, y: 0)
            .scaleEffect(isAtMaxScale ? maxScale : 1)
            .onAppear {
                withAnimation(self.animation, {
                    self.isAtMaxScale.toggle()
                })
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
