//
//  BrightnessFilter.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/10/28.
//  Copyright © 2018年 Colin. All rights reserved.
//

public class BrightnessFilter: BasicOperation {
    public var brightness: Float = 0.0 {
        didSet {
            uniformSettings[0] = brightness
        }
    }
    
    public init() {
        super.init(fragmentFunctionName:"brightnessFragment", numberOfInputs:1)
        
        uniformSettings.appendUniform(0.0)
    }
}
