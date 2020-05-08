//
//  ContentView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/6/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

let NPCSize: CGFloat = 50
let PlayerSize: CGFloat = 60

var currentPosition: CGSize = .zero
var newPosition: CGSize = .zero

// MARK: - NPC
struct NPCView: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: NPCSize, height: NPCSize)
    }
}

struct NPCMap: View {
    @Binding var userDragging: Bool
    @Binding var npcCoords: [ScreenCoordinate]
    
    var body: some View {
        ZStack {
            ForEach(npcCoords, id: \.self) { coord in
                NPCView()
                    .position(x: coord.x, y: coord.y)
                    .opacity(self.userDragging ? 0.5 : 1.0)
                    .animation(.easeInOut)
            }
        }
        
    }
}

// MARK: - Player
struct PlayerView: View {
    
    @Binding var inputX: CGFloat
    @Binding var inputY: CGFloat
    @Binding var showPathPreview: Bool
    
    var body: some View {
        
        ZStack {
            // path preview
            Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .offset(destinationPreviewCalculation(inputX: inputX, inputY: inputY))
                .foregroundColor(Color.red.opacity(showPathPreview ? 1 : 0))
                .font(.system(size: 25, weight: .bold))
            
            // player icon
            Circle()
                .frame(width: PlayerSize, height: PlayerSize)
                .foregroundColor(Color.blue)
                .animation(Animation.easeInOut.speed(5))
            
        }
        .offset(showPathPreview ? newPosition : playerCurrentPosition())
        
        
    }
    
    private func playerCurrentPosition() -> CGSize {
        
        let jump = destinationPreviewCalculation(inputX: inputX, inputY: inputY)
        
        currentPosition = CGSize(width: jump.width + newPosition.width, height: jump.height + newPosition.height)
        
        newPosition = currentPosition
        
        return newPosition
    }
    
    private func destinationPreviewCalculation(inputX: CGFloat, inputY: CGFloat) -> CGSize {
        let vectorDirectoin = CGSize(width: -inputX, height: -inputY)
        
        var vX = vectorDirectoin.width
        var vY = vectorDirectoin.height
        
        let const: CGFloat = 10
        
        if vX <= 0 {
            //            vX = -(-vX).squareRoot() * const
            vX = -distanceFormula(input: -vX) * const
        } else {
            //            vX = vX.squareRoot() * const
            vX = distanceFormula(input: vX) * const
        }
        
        if vY <= 0 {
            //            vY = -(-vY).squareRoot() * const
            vY = -distanceFormula(input: -vY) * const
        } else {
            //            vY = vY.squareRoot() * const
            vY = distanceFormula(input: vY) * const
        }
        
        let result = CGSize(width: vX, height: vY)
        
        return result
    }
    
    private func distanceFormula(input: CGFloat) -> CGFloat {
        let square = input * input
        let ans = 30 * square/(9999 + (square-input))
        return ans
    }
    
}

// MARK: - Interface
struct InterfaceView: View {
    
    @Binding var distance: CGFloat
    @Binding var xDistance: CGFloat
    @Binding var yDistance: CGFloat
    @Binding var userDragging: Bool
    @Binding var passengerCoords: [ScreenCoordinate]
    
    let passengerCount: Int = 10
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("distance: \(self.distance)")
                }
            }
            
            Spacer()
            
            NPCMap(userDragging: $userDragging, npcCoords: $passengerCoords)
            
            PlayerView(inputX: $xDistance, inputY: $yDistance, showPathPreview: $userDragging)
        }
        .background(Color.white.opacity(0.00001))
        
    }
}

// MARK: - ContentView
struct ContentView: View {
    
    @State private var xDistance: CGFloat = 0
    @State private var yDistance: CGFloat = 0
    @State private var distance: CGFloat = 0
    @State private var isDragging: Bool = false
    
    @State private var viewWidth: CGFloat = 0
    @State private var viewHeight: CGFloat = 0
    
    @State private var npcInitialCoords: [ScreenCoordinate] = []
    
    @State private var npcCount = 10
    
    @State private var initialized = false
    
    var body: some View {
        VStack {
            
            if !initialized {
                GeometryReader { geometry in
                    Button(action: {
                        self.viewWidth = geometry.size.width
                        self.viewHeight = geometry.size.height
                        self.npcInitialCoords = self.generateNPCCoords(viewWidth: self.viewWidth, viewHeight: self.viewHeight)
                        self.initialized = true
                    }) {
                        Text("Initialize")
                    }
                    
                }.edgesIgnoringSafeArea(.all)
            } else {
                InterfaceView(distance: $distance, xDistance: $xDistance, yDistance: $yDistance, userDragging: $isDragging, passengerCoords: $npcInitialCoords)
                    .gesture(DragGesture()
                        .onChanged({ value in
                            self.isDragging = true
                            self.xDistance = value.translation.width
                            self.yDistance = value.translation.height
                            self.distance = (self.xDistance * self.xDistance + self.yDistance * self.yDistance).squareRoot()
                            
                        })
                        .onEnded({ (value) in
                            self.isDragging = false
                        })
                )
            }
            
        }
        
    }
    
    private func generateNPCCoords(viewWidth: CGFloat, viewHeight: CGFloat) -> [ScreenCoordinate] {
        var resultCoords: [ScreenCoordinate] = []
        for _ in 0...npcCount {
            var localSlotX = Int((viewWidth / NPCSize) - 1)
            var randX = CGFloat(Int.random(in: 0...localSlotX) * Int(NPCSize) + Int(NPCSize) / 2)
            resultCoords.forEach { coord in
                if coord.x == randX {
                    localSlotX = Int((viewWidth / NPCSize) - 1)
                    randX = CGFloat(Int.random(in: 0...localSlotX) * Int(NPCSize) + Int(NPCSize) / 2)
                }
            }
            
            var localSlotY = Int((viewHeight / NPCSize) - 3)
            var randY = CGFloat(Int.random(in: 0...localSlotY) * Int(NPCSize) + Int(NPCSize) / 2)
            
            resultCoords.forEach { coord in
                if coord.y == randY {
                    localSlotY = Int((viewHeight / NPCSize) - 3)
                    randY = CGFloat(Int.random(in: 0...localSlotY) * Int(NPCSize) + Int(NPCSize) / 2)
                }
            }
            
            let coord = ScreenCoordinate(x: randX, y: randY)
            
            resultCoords.append(coord)
        }
        return resultCoords
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
