//
//  StoryView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/16/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

public struct StoryView: View {
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
                
                Spacer()
            }
            .opacity(animate3Start ? 0 : 1)
            .onAppear {
                self.animate1Start = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                    self.animate1End = true
                }
            }
            
            VStack {
                Spacer()
                
                Image(uiImage: UIImage(named: "research")!)
                    .resizable()
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
                    
                Image(uiImage: UIImage(named: "factory1")!)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .opacity(animate3Start ? 1 : 0)
                    .animation(Animation.easeInOut)
                    .offset(y: self.animate5Start ? 1000 : 0)
                
                Spacer()
                
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
                
                Spacer()
            }
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
