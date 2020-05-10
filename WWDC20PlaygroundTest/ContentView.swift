//
//  ContentView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/6/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

let NPCSize: CGFloat = 40
let PlayerSize: CGFloat = 45

var currentPosition: CGSize = .zero
var newPosition: CGSize = .zero

var npcCoords: [ScreenCoordinate] = []

public func getDistance(x: CGFloat, y: CGFloat) -> CGFloat {
    return (x * x + y * y).squareRoot()
}

// MARK: - Animation
struct Shake: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit: CGFloat = 5
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX: amount * sin(animatableData * .pi * shakesPerUnit), y: 0)
        )
    }
}

struct MoveNPC: GeometryEffect {
    var destCoord: ScreenCoordinate
    var multiplier: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX: destCoord.x * multiplier, y: destCoord.y * multiplier)
        )
        
        
    }
}

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

// MARK: - NPC
struct NPCView: View {
    
    @Binding var isDragging: Bool
    
    @State var attempts: CGFloat = 0
    
    var initialCoord: ScreenCoordinate
    
    var body: some View {
        
        ZStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: NPCSize, height: NPCSize)
                .opacity(self.isDragging ? 0.6 : 1.0)
                .animation(Animation.easeInOut.speed(0.8))
                .clipShape(Circle())
            
            // warning range indicator
            Circle()
                .frame(width: NPCSize * 1.5, height: NPCSize * 1.5)
                .opacity(self.isDragging ? 0 : 0)
                .overlay(
                    Circle()
                        .stroke(Color.red.opacity(self.isDragging ? 0.9 : 0), lineWidth: self.isDragging ? NPCSize/2 : 0)
                        .animation(Animation.easeInOut.speed(0.8))
            )
        }
        .position(x: initialCoord.x, y: initialCoord.y)
        .modifier(anim())
        .gesture(
            TapGesture()
                .onEnded({ value in
                    self.attempts += 1
                })
        )
        
    }
    
    func anim() -> MoveNPC {
        MoveNPC(destCoord: ScreenCoordinate(x: 100, y: 100), multiplier: attempts)
    }
    
}

struct NPCMap: View {
    @Binding var isDragging: Bool
    //    @Binding var npcCoords: [ScreenCoordinate]
    
    var body: some View {
        ZStack {
            ForEach(npcCoords, id: \.self) { coord in
                NPCView(isDragging: self.$isDragging, initialCoord: coord)
                
                
            }
        }
        
    }
}

// MARK: - Player
struct MovePathIndicatorView: View {
    @Binding var showPathPreview: Bool
    @State var destCoord: CGSize
    
    var body: some View {
        Image(systemName: "xmark.circle")
            .resizable()
            .frame(width: PlayerSize, height: PlayerSize)
            .offset(destCoord)
            .foregroundColor(Color.blue.opacity(showPathPreview ? 1 : 0))
            .font(.system(size: 25, weight: .bold))
    }
}


struct PlayerView: View {
    
    @Binding var inputX: CGFloat
    @Binding var inputY: CGFloat
    @Binding var showPathPreview: Bool
    
    @State var attempts: Int = 0
    
    var body: some View {
        
        ZStack {
            
            // path preview
            Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: PlayerSize, height: PlayerSize)
                .offset(destinationPreviewCalculation(inputX: inputX, inputY: inputY))
                .foregroundColor(Color.red.opacity(showPathPreview ? 1 : 0))
                .font(.system(size: 25, weight: .bold))
            
            // player icon
            Circle()
                .frame(width: PlayerSize, height: PlayerSize)
                .foregroundColor(Color.blue)
                // warning animation modifier
                .modifier(Shake(animatableData: CGFloat(attempts)))
                // movement animation
                .animation(Animation.spring(response: 0.3, dampingFraction: 0.825, blendDuration: 0))
            
        }
        .offset(showPathPreview ? newPosition : playerCurrentPosition())
        
    }
    
    private func playerCurrentPosition() -> CGSize {
        
        let jump = destinationPreviewCalculation(inputX: inputX, inputY: inputY)
        
        currentPosition = CGSize(width: jump.width + newPosition.width, height: jump.height + newPosition.height)
        
        if currentPosition.width + viewWidth/2 < 0 {
            print("negative")
            
            // have to use async here to prevent updating state variable during UI rerendering
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // trigger shaking animation to indicate invalid move warning
                withAnimation(.default) {
                    self.attempts += 1
                    self.showPathPreview = true
                }
            }
            
        } else {
            newPosition = currentPosition
        }
        
        let gameStatus = gameEndingJudgment()
        if gameStatus.ended {
            //
        } else {
            //
        }
        
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
    
    private func gameEndingJudgment() -> (ended: Bool, passed: Bool) {
        return (ended: true, passed: false)
    }
    
}

// MARK: - Interface
struct InterfaceView: View {
    
    @Binding var distance: CGFloat
    @Binding var xDistance: CGFloat
    @Binding var yDistance: CGFloat
    @Binding var isDragging: Bool
    
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
            
            PlayerView(inputX: $xDistance, inputY: $yDistance, showPathPreview: $isDragging)
        }
        .background(Color.white.opacity(0.00001))
        
    }
}

var viewWidth: CGFloat = 0
var viewHeight: CGFloat = 0

// MARK: - ContentView
struct ContentView: View {
    
    @State private var xDistance: CGFloat = 0
    @State private var yDistance: CGFloat = 0
    @State private var distance: CGFloat = 0
    @State private var isDragging: Bool = false
    
    @State private var npcCount = 15
    
    @State private var initialized = false
    
    var body: some View {
        ZStack {
            
            VStack {
                
                if !initialized {
                    GeometryReader { geometry in
                        Button(action: {
                            viewWidth = geometry.size.width
                            viewHeight = geometry.size.height
                            npcCoords = self.generateNPCCoords(viewWidth: viewWidth, viewHeight: viewHeight)
                            self.initialized = true
                        }) {
                            Text("Initialize")
                        }
                    }
                    
                } else {
                    InterfaceView(distance: $distance, xDistance: $xDistance, yDistance: $yDistance, isDragging: $isDragging)
                        .gesture(DragGesture()
                            .onChanged({ value in
                                self.isDragging = true
                                self.xDistance = value.translation.width
                                self.yDistance = value.translation.height
                                self.distance = getDistance(x: self.xDistance, y: self.yDistance)
                                
                            })
                            .onEnded({ (value) in
                                self.isDragging = false
                            })
                    )
                }
                
            }
            
            GroundMapView()
            
        }
        
    }
    
    private func generateNPCCoords(viewWidth: CGFloat, viewHeight: CGFloat) -> [ScreenCoordinate] {
        var resultCoords: [ScreenCoordinate] = []
        for _ in 0...npcCount {
            
            var localSlotX = Int((viewWidth / (NPCSize * 1.5)) - 1)
            var randX = CGFloat(Int.random(in: 0...localSlotX) * Int((NPCSize * 1.5)) + Int((NPCSize * 1.5)) / 2)
            resultCoords.forEach { coord in
                if coord.x == randX {
                    localSlotX = Int((viewWidth / (NPCSize * 1.5)) - 1)
                    randX = CGFloat(Int.random(in: 0...localSlotX) * Int((NPCSize * 1.5)) + Int((NPCSize * 1.5)) / 2)
                }
            }
            
            var localSlotY = Int((viewHeight / (NPCSize * 1.5)) - 3)
            var randY = CGFloat(Int.random(in: 0...localSlotY) * Int((NPCSize * 1.5)) + Int((NPCSize * 1.5)) / 2)
            
            resultCoords.forEach { coord in
                if coord.y == randY {
                    localSlotY = Int((viewHeight / (NPCSize * 1.5)) - 3)
                    randY = CGFloat(Int.random(in: 0...localSlotY) * Int((NPCSize * 1.5)) + Int((NPCSize * 1.5)) / 2)
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
