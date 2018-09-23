//
//  Context.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/9/1.
//  Copyright © 2018年 Colin. All rights reserved.
//

import Foundation
import MetalKit

public let sharedContext = Context()

public class Context {
    
    public let device: MTLDevice
    public let commandQueue: MTLCommandQueue
    public let defaultLibrary: MTLLibrary
    
    public let textureLoader: MTKTextureLoader

    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not create Metal Device")
        }
        self.device = device
        
        guard let queue = self.device.makeCommandQueue() else {
            fatalError("Could not create command queue")
        }
        self.commandQueue = queue
        
        do {
            let frameworkBundle = Bundle(for: Context.self)
            let metalLibraryPath = frameworkBundle.path(forResource: "default", ofType: "metallib")!
            
            self.defaultLibrary = try device.makeLibrary(filepath:metalLibraryPath)
        } catch {
            fatalError("Could not load library")
        }
        
        self.textureLoader = MTKTextureLoader(device: self.device)
    }
}
