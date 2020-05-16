//
//  NPCUI.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/15/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import Foundation
import SwiftUI

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
    
    @State var index: Int
    
    @State var npcCurrentCoords: [ScreenCoordinate]
    
    var body: some View {
        
        NPCInternalView(isDragging: $isDragging)
            .position(x: 0, y: 0)
            .offset(x: npcCurrentCoords[npcCurrentCoords.endIndex-1].x, y: npcCurrentCoords[npcCurrentCoords.endIndex-1].y)
            .animation(Animation.linear(duration: 1))
            .onAppear {
                self.toNewPosition()
        }
        
    }
    
    func toNewPosition() {
        if !isDragging {
            let const: CGFloat = 8
            
            let previousCoord = npcCurrentCoords[npcCurrentCoords.endIndex-1]
            
            var xMove = CGFloat.random(in: -const...const)
            var yMove = CGFloat.random(in: -const...const)
            
            
            while outOfView(coord: ScreenCoordinate(x: previousCoord.x + xMove, y: previousCoord.y + yMove)) {
                xMove = CGFloat.random(in: -const...const)
                yMove = CGFloat.random(in: -const...const)
            }
            
            npcCurrentCoords.append(ScreenCoordinate(x: previousCoord.x + xMove, y: previousCoord.y + yMove))
            
            npcCoords[self.index] = self.npcCurrentCoords
            
            print(npcCoords[self.index].last)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 1...1)) {
            
            npcCoords[self.index] = self.npcCurrentCoords
            self.toNewPosition()
            //            npcCoords[self.index] = self.npcCurrentCoords
        }
    }
    
}

public struct NPCMap: View {
    
    @Binding var isDragging: Bool
    
    public init(isDragging: Binding<Bool>) {
        self._isDragging = isDragging
    }
    
    public var body: some View {
        ZStack {
            ForEach(npcCoords, id: \.self) { coord in
                NPCView(isDragging: self.$isDragging, index: npcCoords.firstIndex(of: coord)!, npcCurrentCoords: coord)
            }
        }
            .drawingGroup() // enable off-screen Metal rendering
    }
}
