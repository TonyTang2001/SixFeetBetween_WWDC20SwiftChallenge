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
    var x: CGFloat
    var y: CGFloat
}

// MARK: - View Information
public var viewWidth: CGFloat = 0
public var viewHeight: CGFloat = 0

// MARK: - Game Setting
public let npcSize: CGFloat = 30
public let playerSize: CGFloat = 35
public let npcWarningRangeSize: CGFloat = npcSize * 1.5
public let safetyDistance: CGFloat =  (npcSize*2 + playerSize)/2

// MARK: - Player Info
public var previousPosition: CGSize = .zero
public var currentPosition: CGSize = .zero
public var newPosition: CGSize = .zero

// MARK: - NPC Coordination
public var npcCoords: [[ScreenCoordinate]] = [[]]

// MARK: - Game Status
public var playerWon: Bool = false
public var started: Bool = false
