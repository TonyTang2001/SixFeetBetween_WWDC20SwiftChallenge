//
//  TutorialView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/16/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

public struct TutorialView: View {
    
    var tutorial1String = ["Welcome to training session,",
                           "You will be taught several skills",
                           "to better navigate through difficulties."]
    
    public init() {}
    
    @State var animate1Start = false
    @State var animate1End = false
    @State var animate2Start = false
    @State var animate2End = false
    @State var animate3Start = false
    @State var animate3End = false
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack {
                    ForEach(tutorial1String, id: \.self) { string in
                        Text(string)
                            .fontWeight(.semibold)
                            .font(.system(.title, design: .rounded))
                            .multilineTextAlignment(.center)
                            .opacity(self.animate1Start ? 1 : 0)
                            .offset(y: self.animate1Start ? 0 : 16)
                            .offset(y: 10 * CGFloat(self.tutorial1String.firstIndex(of: string)!))
                            .animation(Animation.easeInOut(duration: 1).delay(
                                Double(self.tutorial1String.firstIndex(of: string)!)
                                )
                        )
                    }
                    .opacity(animate2Start ? 0 : 1)
                }
                
                Spacer()
                
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
                    
                }
                Spacer()
            }
            .opacity(animate3Start ? 0 : 1)
            .onAppear {
                self.animate1Start = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.animate1End = true
                }
            }
            
            VStack {
                Spacer()
                if animate2Start {
                    InTutorialView()
                }
                Spacer()
            }
            
        }
        
    }
}


struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
