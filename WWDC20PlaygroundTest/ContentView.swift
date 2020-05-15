//
//  ContentView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/6/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

var viewWidth: CGFloat = 0
var viewHeight: CGFloat = 0

let npcSize: CGFloat = 30
let npcWarningRangeSize: CGFloat = npcSize * 1.5
let playerSize: CGFloat = 35

let safetyDistance: CGFloat = (npcWarningRangeSize + playerSize)/2

var currentPosition: CGSize = .zero
var newPosition: CGSize = .zero

var npcCoords: [ScreenCoordinate] = []
var npcHistoryCoords: [ScreenCoordinate] = []

var playerWon: Bool = false

public func getLength(x: CGFloat, y: CGFloat) -> CGFloat {
    return (x * x + y * y).squareRoot()
}

public func getDistance(_ point1: ScreenCoordinate, _ point2: ScreenCoordinate) -> CGFloat {
    let p1X = point1.x
    let p1Y = point1.y
    let p2X = point2.x
    let p2Y = point2.y
    
    let xDiff = p1X - p2X
    let yDiff = p1Y - p2Y
    
    let ptDistance = (xDiff * xDiff + yDiff * yDiff).squareRoot()
    
    return ptDistance
}

public func gameStateCheck() -> (ended: Bool, succeeded: Bool) {
    var isEnded = false
    var isSucceeded = false
    let playerPosition = ScreenCoordinate(x: currentPosition.width + viewWidth/2 , y: currentPosition.height + viewHeight - playerSize/2)
    print(playerPosition)
    
    if playerPosition.y < 0 {
        isEnded = true
        isSucceeded = true
        return (isEnded, isSucceeded)
    }
    
    npcCoords.forEach { npcCoord in
        let distance = getDistance(npcCoord, playerPosition)
//        print(distance)
        if distance < safetyDistance {
            isEnded = true
            isSucceeded = false
        }
    }
    
    return (isEnded, isSucceeded)
}

public func outOfView(coord: ScreenCoordinate) -> Bool {
    let coordLeftX = coord.x - 20
    let coordRightX = coord.x + 20
    let coordTopY = coord.y - 20
    let coordBtmY = coord.y + 20
    if coordLeftX < 0 || coordRightX > viewWidth || coordTopY < 0 || coordBtmY > viewHeight {
        return true
    } else {
        return false
    }
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

extension Animation {
    static func playerMove() -> Animation {
        Animation.spring(response: 0.3, dampingFraction: 0.825, blendDuration: 0)
    }
    
    static func npcTransition() -> Animation {
        Animation.easeInOut.speed(0.6)
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

struct NPCInternalView: View {
    
    @Binding var isDragging: Bool
    
    var body: some View {
        ZStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: npcSize, height: npcSize)
                .opacity(self.isDragging ? 0.6 : 1.0)
                .animation(.npcTransition())
                .clipShape(Circle())
            
            // warning range indicator
            Circle()
                .frame(width: npcWarningRangeSize, height: npcWarningRangeSize)
                .opacity(self.isDragging ? 0 : 0)
                .overlay(
                    Circle()
                        .stroke(Color.red.opacity(self.isDragging ? 0.9 : 0), lineWidth: self.isDragging ? npcSize/2 : 0)
                        .animation(.npcTransition())
            )
        }
            .drawingGroup() // enable off-screen Metal rendering
    }
}

struct NPCView: View {
    
    @Binding var isDragging: Bool
    
    @State var lastCoord: ScreenCoordinate
    
    //    private let continuousAnim = Animation.linear(duration: 3).repeatForever(autoreverses: true)
    
    var body: some View {
        
        NPCInternalView(isDragging: $isDragging)
            .position(x: 0, y: 0)
            .offset(x: lastCoord.x, y: lastCoord.y)
            .animation(Animation.linear(duration: 0.5))
            .onAppear {
                self.toNewPosition()
        }
        .onTapGesture {
            print(self.lastCoord)
        }
        
    }
    
    func toNewPosition() {
        if !isDragging {
            let const: CGFloat = 8
            var xMove = CGFloat.random(in: -const...const)
            var yMove = CGFloat.random(in: -const...const)
            
            while outOfView(coord: ScreenCoordinate(x: lastCoord.x + xMove, y: lastCoord.y + yMove)) {
                xMove = CGFloat.random(in: -const...const)
                yMove = CGFloat.random(in: -const...const)
            }
            
            lastCoord.x += xMove
            lastCoord.y += yMove
            
//            print(lastCoord)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 0.5...0.5)) {
            
            self.toNewPosition()
        }
    }
    
}

struct NPCMap: View {
    
    @Binding var isDragging: Bool
    
    var body: some View {
        ZStack {
            ForEach(npcCoords, id: \.self) { coord in
                NPCView(isDragging: self.$isDragging, lastCoord: coord)
            }
        }
            .drawingGroup() // enable off-screen Metal rendering
    }
}

// MARK: - Player
struct MovePathIndicatorView: View {
    @Binding var showPathPreview: Bool
    @State var destCoord: CGSize
    
    var body: some View {
        Image(systemName: "xmark.circle")
            .resizable()
            .frame(width: playerSize, height: playerSize)
            .offset(destCoord)
            .foregroundColor(Color.blue.opacity(showPathPreview ? 1 : 0))
            .font(.system(size: 25, weight: .bold))
    }
}


struct PlayerView: View {
    
    @Binding var inputX: CGFloat
    @Binding var inputY: CGFloat
    @Binding var showPathPreview: Bool
    @Binding var gameEnded: Bool
    
    @State var invalidMoveCount: Int = 0
    
    var body: some View {
        
        ZStack {
            
            // path preview
            Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: playerSize, height: playerSize)
                .offset(destinationPreviewCalculation(inputX: inputX, inputY: inputY))
                .foregroundColor(Color.red.opacity(showPathPreview ? 1 : 0))
                .font(.system(size: 25, weight: .bold))
            
            // player icon
            Circle()
                .frame(width: playerSize, height: playerSize)
                .foregroundColor(Color.blue)
                // invalid move warning indication
                .modifier(Shake(animatableData: CGFloat(invalidMoveCount)))
                // movement animation
                .animation(.playerMove())
            
        }
        .offset(showPathPreview ? newPosition : playerCurrentPosition())
        
    }
    
    private func playerCurrentPosition() -> CGSize {
        
        let jump = destinationPreviewCalculation(inputX: inputX, inputY: inputY)
        
        currentPosition = CGSize(width: jump.width + newPosition.width, height: jump.height + newPosition.height)
        
        
        if currentPosition.width + viewWidth/2 < 0 || currentPosition.width > viewWidth/2 {
            print("negative")
            
            // have to use async here to prevent updating state variable during UI rerendering
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // trigger shaking animation to indicate invalid move warning
                withAnimation(.default) {
                    self.invalidMoveCount += 1
                    self.showPathPreview = true
                }
            }
            
        } else {
            newPosition = currentPosition
        }
        
        let gameStatus = gameStateCheck()
        if gameStatus.ended {
            // game ended
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.gameEnded = true
            }
            
            if gameStatus.succeeded {
                // player won
                print("player won")
                playerWon = true
            } else {
                // player failed
                print("player lost")
                playerWon = false
            }
        } else {
            // game still gping on
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
struct ContentView: View {
    
    @State private var xDistance: CGFloat = 0
    @State private var yDistance: CGFloat = 0
    @State private var distance: CGFloat = 0
    @State private var isDragging: Bool = false
    
    @State private var npcCount = 20
    
    @State private var initialized = false
    
    @State private var gameEnded = false
    
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
                .edgesIgnoringSafeArea(.bottom)
                .blur(radius: gameEnded ? 26 : 0)
//                .animation(.easeInOut)
            
            GroundMapView()
            
            if gameEnded && playerWon {
                GameSuccessView()
                    .offset(x: 0, y: gameEnded ? 0 : 1000)
                
            } else if gameEnded && !playerWon {
                GameFailureView()
            }
            
        }
        
    }
    
    private func generateNPCCoords(viewWidth: CGFloat, viewHeight: CGFloat) -> [ScreenCoordinate] {
        var resultCoords: [ScreenCoordinate] = []
        for _ in 1...npcCount {
            
            var localSlotX = Int((viewWidth / (npcSize * 1.5)) - 1)
            var randX = CGFloat(Int.random(in: 0...localSlotX) * Int((npcSize * 1.5)) + Int((npcSize * 1.5)) / 2)
            resultCoords.forEach { coord in
                if coord.x == randX {
                    localSlotX = Int((viewWidth / (npcSize * 1.5)) - 1)
                    randX = CGFloat(Int.random(in: 0...localSlotX) * Int((npcSize * 1.5)) + Int((npcSize * 1.5)) / 2)
                }
            }
            
            var localSlotY = Int((viewHeight / (npcSize * 1.5)) - 3)
            var randY = CGFloat(Int.random(in: 0...localSlotY) * Int((npcSize * 1.5)) + Int((npcSize * 1.5)) / 2)
            
            resultCoords.forEach { coord in
                if coord.y == randY {
                    localSlotY = Int((viewHeight / (npcSize * 1.5)) - 3)
                    randY = CGFloat(Int.random(in: 0...localSlotY) * Int((npcSize * 1.5)) + Int((npcSize * 1.5)) / 2)
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
