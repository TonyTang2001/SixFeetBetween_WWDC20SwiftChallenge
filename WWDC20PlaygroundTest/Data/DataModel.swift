//
//  DataModel.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/8/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import Foundation
import SwiftUI

public struct ScreenCoordinate: Hashable {
    public var x: CGFloat
    public var y: CGFloat
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}

// MARK: - View Information
public var viewWidth: CGFloat = 0
public var viewHeight: CGFloat = 0

// MARK: - Game Setting
public let mapIconSize: CGFloat = 50
public let npcCount: Int = 15
public let npcSize: CGFloat = 30
public let playerSize: CGFloat = 35
public let npcWarningRangeSize: CGFloat = npcSize * 1.5
public let safetyDistance: CGFloat =  (npcSize*2 + playerSize)/2

// MARK: - Player Info
public var previousPosition = ScreenCoordinate(x: 0, y: 0)
public var currentPosition: CGSize = .zero
public var newPosition: CGSize = .zero
public var playerColor: Color = Color(UIColor.systemBlue)
public var playerPathColor: Color = Color(UIColor.systemBlue)

// MARK: - NPC Coordination
public var npcCoords: [[ScreenCoordinate]] = [[]]

// MARK: - Game Status
public var playerWon: Bool = false
public var started: Bool = false
public var endOnHold: Bool = false
public var startTime: Date = Date()
public var endTime: Date = Date()
