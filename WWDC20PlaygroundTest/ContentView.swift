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
var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

var playerCoord: CGSize = .zero

struct PassengerView: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
    }
}

var currentPosition: CGSize = .zero
var newPosition: CGSize = .zero

struct PlayerView: View {
    
    @Binding var inputX: CGFloat
    @Binding var inputY: CGFloat
    @Binding var showDest: Bool
    @Binding var playerDest: CGSize
    
    @State var playerposition: CGSize = .zero
    
    var body: some View {
        
        ZStack {
            
//            Text("\(testCG.width)").offset(CGSize(width: 0, height: -100))
//            Text("\(testCG.height)").offset(CGSize(width: 0, height: -120))
            
            Image(systemName: "xmark.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .offset(destinationPreviewCalculation(inputX: inputX, inputY: inputY))
                .foregroundColor(Color.red.opacity(showDest ? 1 : 0))
                .font(.system(size: 25, weight: .bold))
            
            Circle()
                .frame(width: PlayerSize, height: PlayerSize)
                .foregroundColor(Color.blue)
                .animation(Animation.easeInOut.speed(5))
            
        }
        .offset(showDest ? newPosition : playerCurrentPosition())
        
        
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

struct InterfaceView: View {
    
    @Binding var distance: CGFloat
    @Binding var xDistance: CGFloat
    @Binding var yDistance: CGFloat
    @Binding var userDragging: Bool
    @Binding var passengerCoords: [ScreenCoordinate]
    @Binding var playerDest: CGSize
    
    
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
            
            PlayerView(inputX: $xDistance, inputY: $yDistance, showDest: $userDragging, playerDest: $playerDest)
        }
        .background(Color.white.opacity(0.00001))
        
    }
}

struct NPCMap: View {
    @Binding var userDragging: Bool
    @Binding var npcCoords: [ScreenCoordinate]
    
    var body: some View {
        ZStack {
            ForEach(npcCoords, id: \.self) { coord in
                PassengerView()
                    .frame(width: NPCSize, height: NPCSize)
                    .position(x: coord.x, y: coord.y)
                    .opacity(self.userDragging ? 0.5 : 1.0)
                    .animation(.easeInOut)
            }
            
        }
        
    }
}

struct ContentView: View {
    
    @State private var distance: CGFloat = 0
    @State private var xDistance: CGFloat = 0
    @State private var yDistance: CGFloat = 0
    @State private var userDragging: Bool = false
    @State private var playerLocation: CGSize = .zero
    
    @State private var scW: CGFloat = 0
    @State private var scH: CGFloat = 0
    
    @State private var passengerCoords: [ScreenCoordinate] = []
    
    @State private var passengerCount = 10
    
    var body: some View {
        VStack {
            
            GeometryReader { geometry in
                Button(action: {
                    self.passengerCoords = self.generatePassengerCoords()
                    self.scW = geometry.size.width
                    self.scH = geometry.size.height
                }) {
                    Text("\(self.scW),\(self.scH)")
                }
                
            }
            
            
            InterfaceView(distance: $distance, xDistance: $xDistance, yDistance: $yDistance, userDragging: $userDragging, passengerCoords: $passengerCoords, playerDest: $playerLocation)
                .gesture(DragGesture()
                    .onChanged({ value in
                        self.userDragging = true
                        self.xDistance = value.translation.width
                        self.yDistance = value.translation.height
                        self.distance = (self.xDistance * self.xDistance + self.yDistance * self.yDistance).squareRoot()
                        
                    })
                    .onEnded({ (value) in
                        self.userDragging = false
                        
                        self.playerLocation = CGSize(width: value.translation.width, height: value.translation.height)
                    })
            )
        }
        
    }
    
    private func generatePassengerCoords() -> [ScreenCoordinate] {
        //        print(screenWidth)
        //        print(screenHeight)
        //        print(passengerCoords)
        var resultCoords: [ScreenCoordinate] = []
        for _ in 0...passengerCount {
            var localSlotX = Int((screenWidth / NPCSize) - 1)
            var randX = CGFloat(Int.random(in: 0...localSlotX) * Int(NPCSize) + Int(NPCSize) / 2)
            resultCoords.forEach { coord in
                if coord.x == randX {
                    localSlotX = Int((screenWidth / NPCSize) - 1)
                    randX = CGFloat(Int.random(in: 0...localSlotX) * Int(NPCSize) + Int(NPCSize) / 2)
                }
            }
            
            var localSlotY = Int((screenHeight / NPCSize) - 3)
            var randY = CGFloat(Int.random(in: 0...localSlotY) * Int(NPCSize) + Int(NPCSize) / 2)
            
            resultCoords.forEach { coord in
                if coord.y == randY {
                    localSlotY = Int((screenHeight / NPCSize) - 3)
                    randY = CGFloat(Int.random(in: 0...localSlotY) * Int(NPCSize) + Int(NPCSize) / 2)
                }
            }
            
            let coord = ScreenCoordinate(x: randX, y: randY)
            
            resultCoords.append(coord)
        }
        return resultCoords
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


