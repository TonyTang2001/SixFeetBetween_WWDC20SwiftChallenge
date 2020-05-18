//
//  StoryTextIntroView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/17/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

struct StoryTextIntroView: View {
    
    var context1String = ["Sometime in the future,",
                                 "an virus named C9 is emerging worldwide.",
                                 "It has infected a huge amount of people,",
                                 "and everyone is waiting for help.",
                                 "Fortunately, the cure has been developed.",
                                 "",
                                 "However, the research sample has not been delivered",
                                 "to the factory for mass production."]
    var context2String = ["You are a Ninja.",
                                 "The people need your help!",
                                 "",
                                 "You need to transport the sample",
                                 "from the lab to the factory."]
    
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
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                VStack {
                    ForEach(context1String, id: \.self) { string in
                        Text(string)
                            .fontWeight(.semibold)
                            .font(.system(.title, design: .rounded))
                            .multilineTextAlignment(.center)
                            .opacity(self.animate1Start ? 1 : 0)
                            .offset(y: self.animate1Start ? 0 : 16)
                            .offset(y: 10 * CGFloat(self.context1String.firstIndex(of: string)!))
                            .animation(Animation.easeInOut(duration: 1).delay(
                                Double(self.context1String.firstIndex(of: string)!)
                                )
                        )
                    }
                    .opacity(animate2Start ? 0 : 1)
                }
                
                VStack {
                    Image(uiImage: UIImage(named: "Ninja_Circle")!)
                        .resizable()
                        .frame(width: playerSize, height: playerSize)
                        .opacity(self.animate2Start ? 1 : 0)
                    
                    ForEach(context2String, id: \.self) { string in
                        Text(string)
                            .fontWeight(.semibold)
                            .font(.system(.title, design: .rounded))
                            .multilineTextAlignment(.center)
                            .opacity(self.animate2Start ? 1 : 0)
                            .offset(y: self.animate2Start ? 0 : 16)
                            .offset(y: 10 * CGFloat(self.context2String.firstIndex(of: string)!))
                            .animation(Animation.easeInOut(duration: 1).delay(
                                Double(self.context2String.firstIndex(of: string)!)
                                )
                        )
                    }
                    .opacity(animate3Start ? 0 : 1)
                }
            }
            
            
            Spacer()
            
            ButtonStackView1(animate1Start: $animate1Start, animate1End: $animate1End, animate2Start: $animate2Start, animate2End: $animate2End, animate3Start: $animate3Start, animate3End: $animate3End)
            
            Spacer()
        }
    }
}
