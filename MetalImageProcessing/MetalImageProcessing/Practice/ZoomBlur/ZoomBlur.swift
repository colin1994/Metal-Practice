//
//  ZoomBlur.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/11/27.
//  Copyright © 2018 Colin. All rights reserved.
//

import Foundation

public class ZoomBlur: BasicOperation {
    
    public var blurSize: Float = 0.0 {
        didSet {
            uniformSettings[0] = blurSize
        }
    }
    
    public init() {
        super.init(fragmentFunctionName:"zoomBlurFragment", numberOfInputs:1)
        
        uniformSettings.appendUniform(0.0)
    }
}
