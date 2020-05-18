//
//  GameLogistics.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/15/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import Foundation
import SwiftUI

// generate NPC coordinate when game starts
public func generateNPCCoords(viewWidth: CGFloat, viewHeight: CGFloat) -> [[ScreenCoordinate]] {
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

public func playerArriveDest() -> Bool {
    let playerCoord = getPlayerCoord()
    if playerCoord.x <= viewWidth/2 + 2*mapIconSize &&
        playerCoord.x >= viewWidth/2 - 2*mapIconSize &&
        playerCoord.y <= 2*mapIconSize {
        return true
    }
    return false
}

// check if game ends
public func gameStateCheck() -> (ended: Bool, succeeded: Bool) {
    var isEnded = false
    var isSucceeded = false
    let playerPosition = getPlayerCoord()
    
    if playerArriveDest() {
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
        
        let distance = distanceFromPoint(p: npcCoordNow, toLineSegment: previousPosition, and: playerPosition)
        
        if distance < safetyDistance {
            isEnded = true
            isSucceeded = false
        }
    }
    
    return (isEnded, isSucceeded)
}
