//
//  AnimationPresets.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/15/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import Foundation
import SwiftUI

public struct Shake: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit: CGFloat = 5
    
    public var animatableData: CGFloat
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX: amount * sin(animatableData * .pi * shakesPerUnit), y: 0)
        )
    }
}

public extension Animation {
    
    static let playerMove = Animation.spring(response: 0.3, dampingFraction: 0.75, blendDuration: 0)
    
    static let npcTransition = Animation.easeInOut.speed(0.6)
    
}
