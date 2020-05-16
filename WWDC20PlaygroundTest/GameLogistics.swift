//
//  GameLogistics.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/15/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import Foundation

public func gameStateCheck() -> (ended: Bool, succeeded: Bool) {
    var isEnded = false
    var isSucceeded = false
    let playerPosition = ScreenCoordinate(x: currentPosition.width + viewWidth/2 , y: currentPosition.height + viewHeight - playerSize/2)
    
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
        
        
        print("npc: \(npcCoordNow)")
        print("player: \(previousPosition)")
        print("player: \(playerPosition)")
        
        let distance = getDistance(npcCoordNow, playerPosition)
        print("distance: \(distance)")
        if distance <= safetyDistance {
            isEnded = true
            isSucceeded = false
        }
    }
    
    return (isEnded, isSucceeded)
}
