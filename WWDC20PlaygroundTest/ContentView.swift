//
//  ContentView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/6/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

// MARK: - MapSetting
struct GroundMapView: View {
    var body: some View {
        VStack {
            Image(systemName: "house")
            
            Spacer()
            
            Image(systemName: "house")
        }
    }
}

// MARK: - Interface
struct InterfaceView: View {
    
    @Binding var distance: CGFloat
    @Binding var xDistance: CGFloat
    @Binding var yDistance: CGFloat
    @Binding var isDragging: Bool
    
    @Binding var gameEnded: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("distance: \(self.distance)")
                }
            }
            
            Spacer()
            
            NPCMap(isDragging: $isDragging)
            
            PlayerView(inputX: self.$xDistance, inputY: self.$yDistance, showPathPreview: self.$isDragging, gameEnded: $gameEnded)
            
        }
        .background(Color.white.opacity(0.00001))
        
    }
}

// MARK: - ContentView
public struct ContentView: View {
    
    @State private var xDistance: CGFloat = 0
    @State private var yDistance: CGFloat = 0
    @State private var distance: CGFloat = 0
    @State private var isDragging: Bool = false
    
    @State private var viewW: CGFloat = 400
    @State private var viewH: CGFloat = 600
    
    @State private var npcCount = 15
    
    @State private var initialized = false
    
    @State private var gameEnded = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            
            BackgroundView(canvasWidth: $viewW, canvasHeight: $viewH)
            
            VStack {
                
                if !initialized {
                    GeometryReader { geometry in
                        Button(action: {
                            viewWidth = geometry.size.width
                            viewHeight = geometry.size.height
                            
                            self.viewW = viewWidth
                            self.viewH = viewHeight
                            
                            npcCoords = self.generateNPCCoords(viewWidth: viewWidth, viewHeight: viewHeight)
                            self.initialized = true
                        }) {
                            Text("Start Game")
                                .foregroundColor(Color(UIColor.systemYellow))
                                .fontWeight(.semibold)
                                .font(.system(.title, design: .rounded))
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                } else {
                    InterfaceView(distance: $distance, xDistance: $xDistance, yDistance: $yDistance, isDragging: $isDragging, gameEnded: $gameEnded)
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
                }
                
            }
            .edgesIgnoringSafeArea(.all)
            .blur(radius: gameEnded ? 26 : 0)
            
            GroundMapView()
            
            if gameEnded && playerWon {
                GameSuccessView()
            } else if gameEnded && !playerWon {
                GameFailureView()
            }
            
        }
        
    }
    
    private func generateNPCCoords(viewWidth: CGFloat, viewHeight: CGFloat) -> [[ScreenCoordinate]] {
        var resultCoords: [[ScreenCoordinate]] = [[]]
        
        for _ in 0..<npcCount {
            
            var localSlotX = Int((viewWidth / (npcSize * 1.5)) - 1)
            var randX = CGFloat(Int.random(in: 0...localSlotX) * Int((npcSize * 1.5)) + Int((npcSize * 1.5)) / 2)
            
            resultCoords.forEach { coordArray in
                guard let coord = coordArray.last else { return }
                if coord.x == randX {
                    localSlotX = Int((viewWidth / (npcSize * 1.5)) - 1)
                    randX = CGFloat(Int.random(in: 0...localSlotX) * Int((npcSize * 1.5)) + Int((npcSize * 1.5)) / 2)
                }
            }
            
            var localSlotY = Int((viewHeight / (npcSize * 1.5)) - 3)
            var randY = CGFloat(Int.random(in: 0...localSlotY) * Int((npcSize * 1.5)) + Int((npcSize * 1.5)) / 2)
            
            resultCoords.forEach { coordArray in
                guard let coord = coordArray.last else { return }
                if coord.y == randY {
                    localSlotY = Int((viewHeight / (npcSize * 1.5)) - 3)
                    randY = CGFloat(Int.random(in: 0...localSlotY) * Int((npcSize * 1.5)) + Int((npcSize * 1.5)) / 2)
                }
            }
            
            let coord = [ScreenCoordinate(x: randX, y: randY)]
            
            resultCoords.append(coord)
        }
        resultCoords.remove(at: 0)
        return resultCoords
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
