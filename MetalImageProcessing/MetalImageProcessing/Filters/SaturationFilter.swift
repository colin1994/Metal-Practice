//
//  SaturationFilter.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/11/3.
//  Copyright © 2018 Colin. All rights reserved.
//

import Foundation

public class SaturationFilter: BasicOperation {
    public var saturation: Float = 1.0 {
        didSet {
            uniformSettings[0] = saturation
        }
    }
    
    public init() {
        super.init(fragmentFunctionName:"saturationFragment", numberOfInputs:1)
        
        uniformSettings.appendUniform(1.0)
    }
}
