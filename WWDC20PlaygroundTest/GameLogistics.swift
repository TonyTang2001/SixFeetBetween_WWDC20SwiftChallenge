//
//  GameLogistics.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/15/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import Foundation
import SwiftUI

public func gameStateCheck() -> (ended: Bool, succeeded: Bool) {
    var isEnded = false
    var isSucceeded = false
    let playerPosition = getPlayerCoord()
    
    if playerPosition.y < 0 {
        isEnded = true
        isSucceeded = true
        return (isEnded, isSucceeded)
    }
    
    npcCoords.forEach { npcCoordArray in
        var npcCoordNow: ScreenCoordinate
        
        if npcCoordArray.endIndex < 2 {
            npcCoordNow = npcCoordArray[npcCoordArray.endIndex-1]
        } else {
            npcCoordNow = npcCoordArray[npcCoordArray.endIndex-1]
        }
        
        
//        print("npc: \(npcCoordNow)")
//        print("player: \(previousPosition)")
//        print("player: \(playerPosition)")
//        print(distanceFromPoint(p: npcCoordNow, toLineSegment: previousPosition, and: playerPosition))
        let distance = distanceFromPoint(p: npcCoordNow, toLineSegment: previousPosition, and: playerPosition)
        
        if distance < safetyDistance {
            isEnded = true
            isSucceeded = false
        }
    }
    
    return (isEnded, isSucceeded)
}
