//
//  LookupFilter.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/11/1.
//  Copyright © 2018 Colin. All rights reserved.
//

public class LookupFilter: BasicOperation {
    public var intensity: Float = 1.0 {
        didSet {
            uniformSettings[0] = intensity
        }
    }
    
    public var lookupImage: PictureInput? {
        didSet {
            lookupImage?.addTarget(self, atTargetIndex:1)
            lookupImage?.processImage()
        }
    }
    
    public init() {
        super.init(fragmentFunctionName:"lookupFragment", numberOfInputs:2)
        
        uniformSettings.appendUniform(1.0)
    }
}
