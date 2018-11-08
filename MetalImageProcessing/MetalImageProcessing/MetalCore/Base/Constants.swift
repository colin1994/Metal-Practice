//
//  Constants.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/9/2.
//  Copyright © 2018年 Colin. All rights reserved.
//

import Foundation
import Metal

public let standardImageVertices: [Float] = [-1.0, -1.0, 1.0, -1.0, -1.0, 1.0, 1.0, 1.0]
public let verticallyInvertedImageVertices: [Float] = [-1.0, 1.0, 1.0, 1.0, -1.0, -1.0, 1.0, -1.0]

public let standardTextureCoordinates: [Float] = [0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0]

enum FunctionName {
    static let OneInputVertex = "oneInputVertex"
    static let TwoInputVertex = "twoInputVertex"
    static let PassthroughFragment = "passthroughFragment"
    
    static func defaultVertexFunctionNameForInputs(_ inputCount:UInt) -> String {
        switch inputCount {
        case 1:
            return OneInputVertex
        case 2:
            return TwoInputVertex
        default:
            return OneInputVertex
        }
    }
}

public enum RenderColor {
    static let clearColor = MTLClearColorMake(0.85, 0.85, 0.85, 1)
}
