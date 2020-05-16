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
