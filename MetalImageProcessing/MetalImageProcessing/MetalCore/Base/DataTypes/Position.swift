//
//  Position.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/10/26.
//  Copyright © 2018年 Colin. All rights reserved.
//

import Foundation
import UIKit

public struct Position {
    public let x: Float
    public let y: Float
    public let z: Float
    public let w: Float

    public init (_ x: Float, _ y: Float, _ z: Float = 0.0, _ w: Float = 0.0) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    public init(point: CGPoint) {
        self.x = Float(point.x)
        self.y = Float(point.y)
        self.z = 0.0
        self.w = 0.0
    }
    public static let center = Position(0.5, 0.5)
    public static let zero = Position(0.0, 0.0)
}
