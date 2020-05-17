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
//                    .opacity(animate2Start ? 1 : 0)
                }
                
                
                Spacer()
            }
            
            
            
        }
    }
}

public struct InTutorialView: View {
    
    @State private var xDistance: CGFloat = 0
    @State private var yDistance: CGFloat = 0
    @State private var distance: CGFloat = 0
    @State private var isDragging: Bool = false
    
    @State var animate1Start = false
    @State var animate1End = false
    @State var animate2Start = false
    @State var animate2End = false
    @State var animate3Start = false
    @State var animate3End = false
    @State var animate4Start = false
    @State var animate4End = false
    @State var animate5Start = false
    @State var animate5End = false
    @State var animate6Start = false
    
    public init() {}
    public var body: some View {
        ZStack {
            VStack {
                Image(uiImage: UIImage(named: "factory1")!)
                    .resizable()
                    .frame(width: mapIconSize, height: mapIconSize)
                    .opacity(self.animate2Start ? 1 : 0)
                
                Spacer()
                
                Image(uiImage: UIImage(named: "research")!)
                    .resizable()
                    .frame(width: mapIconSize, height: mapIconSize)
                    .opacity(self.animate1Start ? 1 : 0)
            }
            .animation(Animation.easeInOut(duration: 0.8))
            
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
            .opacity((self.animate1Start && !self.animate2End) ? 1 : 0)
            .animation(Animation.easeInOut(duration: 0.8))
            
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
            .opacity((self.animate3Start && !self.animate3End) ? 1 : 0)
            .animation(Animation.easeInOut(duration: 0.8))
            
            VStack {
                Spacer()
                
                Text("To reach your destination, \nyou will need to use \"Bink\".\n\nTo move, just drag anywhere on screen, \nninja will blink once you release your finger.\n\nJust TRY IT OUT!")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity((self.animate4Start && !self.animate4End) ? 1 : 0)
                    .animation(Animation.easeInOut(duration: 0.8))
                
                Spacer()
                
                PlayerView(inputX: $xDistance, inputY: $yDistance, showPathPreview: $isDragging, gameEnded: .constant(false), tutorialMode: true)
                
                Spacer()
                
                Button(action: {
                    self.animate4End = true
                    self.animate5Start = true
                }) {
                    Text("Next")
                        .fontWeight(.semibold)
                        .font(.system(.title, design: .rounded))
                }
                .opacity((self.animate4Start && !self.animate4End) ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.8))
                
                Spacer()
            }
                .background(Color.white.opacity(0.00001))
                .gesture(DragGesture()
                    .onChanged({ value in
                        self.isDragging = true
                        self.xDistance = value.translation.width
                        self.yDistance = value.translation.height
                        self.distance = getLength(x: self.xDistance, y: self.yDistance)
                        
                    })
                    .onEnded({ (value) in
                        self.isDragging = false
                    })
                )
                .opacity((self.animate4Start && !self.animate4End) ? 1 : 0)
            
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
            .opacity((self.animate5Start && !self.animate5End) ? 1 : 0)
            .animation(Animation.easeInOut(duration: 0.8))
            
            VStack {
                Spacer()
                Spacer()
                Text("That's all.\nIt's your time to save the world.")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity(self.animate6Start ? 1 : 0)
                Spacer()
                Text("Go to the Next page to start.")
                    .fontWeight(.semibold)
                    .font(.system(.callout, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity(self.animate6Start ? 1 : 0)
                Spacer()
            }
            .opacity(self.animate6Start ? 1 : 0)
            .animation(Animation.easeInOut(duration: 0.8))
            
        }
        .onAppear {
            self.animate1Start = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.animate2Start = true
            }
        }
        
        
        
    }
    
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}

//struct InTutorialView_Previews: PreviewProvider {
//    static var previews: some View {
//        InTutorialView()
//    }
//}
