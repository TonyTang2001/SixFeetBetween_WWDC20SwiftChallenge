//
//  Calculation.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/15/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import Foundation
import SwiftUI

// get length using sqrt of x and y squares
public func getLength(x: CGFloat, y: CGFloat) -> CGFloat {
    return (x * x + y * y).squareRoot()
}

// get length between two screen coordinates
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

// check if npc approches player
public func approachPlayer(_ npc: ScreenCoordinate, _ player: ScreenCoordinate) -> Bool {
    let distance = getDistance(npc, player)
    if distance <= safetyDistance {
        return true
    } else {
        return false
    }
}

// calculate player exact coordinate
public func getPlayerCoord() -> ScreenCoordinate {
    let playerPosition = ScreenCoordinate(x: currentPosition.width + viewWidth/2 , y: currentPosition.height + viewHeight - playerSize/2)
    return playerPosition
}

// check if the coordinate is out of view
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

// calculate shortest length from a point to a line segment
public func distanceFromPoint(p: ScreenCoordinate, toLineSegment v: ScreenCoordinate, and w: ScreenCoordinate) -> CGFloat {
    let pv_dx = p.x - v.x
    let pv_dy = p.y - v.y
    let wv_dx = w.x - v.x
    let wv_dy = w.y - v.y

    let dot = pv_dx * wv_dx + pv_dy * wv_dy
    let len_sq = wv_dx * wv_dx + wv_dy * wv_dy
    let param = dot / len_sq

    var int_x, int_y: CGFloat /* intersection of normal to vw that goes through p */

    if param < 0 || (v.x == w.x && v.y == w.y) {
        int_x = v.x
        int_y = v.y
    } else if param > 1 {
        int_x = w.x
        int_y = w.y
    } else {
        int_x = v.x + param * wv_dx
        int_y = v.y + param * wv_dy
    }

    /* Components of normal */
    let dx = p.x - int_x
    let dy = p.y - int_y

    return sqrt(dx * dx + dy * dy)
}

// get game duration from start to end
public func getGameDuration(from start: Date, to end: Date) -> Int  {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)

    let seconds = dateComponents.second
    return Int(seconds!)
}

// get game rating
public func getGameRating(duration: Int) -> Int {
    if duration < npcCount/2 {
        return 3
    } else if duration < npcCount {
        return 2
    } else {
        return 1
    }
}

// check if player is out of screen view
public func playerOutOfView() -> Bool {
    let playerDest = getPlayerCoord()
    let playerLeftX = playerDest.x - playerSize/2
    let playerRightX = playerDest.x + playerSize/2
    let playerTopY = playerDest.y - playerSize/2
    let playerBottomY = playerDest.y + playerSize/2
    
    if playerLeftX < 0 || playerRightX > viewWidth ||
        playerTopY < 0 || playerBottomY > viewHeight  {
        return true
    }
    
    return false
}

// calculate player destination using user dragging one-axis distance
public func calculateMoveEstimate(input: CGFloat) -> CGFloat {
    let square = input * input
    let ans = 30 * square/(9999 + (square-input))
    return ans
}
