//
//  Rendering.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/9/2.
//  Copyright © 2018年 Colin. All rights reserved.
//

import Foundation
import Metal

extension MTLCommandBuffer {
    func renderQuad(pipelineState: MTLRenderPipelineState, uniformSettings:ShaderUniformSettings? = nil, inputTextures: [UInt:Texture], outputTexture: Texture,  clearColor: MTLClearColor = RenderColor.clearColor, imageVertices: [Float] = verticallyInvertedImageVertices, textureCoordinates: [Float] = standardTextureCoordinates) {
        let vertexBuffer = sharedContext.device.makeBuffer(bytes: imageVertices,
                                                           length: imageVertices.count * MemoryLayout<Float>.size,
                                                           options: [])!
        let renderPass = MTLRenderPassDescriptor()
        renderPass.colorAttachments[0].texture = outputTexture.texture
        renderPass.colorAttachments[0].clearColor = clearColor
        renderPass.colorAttachments[0].storeAction = .store
        renderPass.colorAttachments[0].loadAction = .clear
        
        guard let renderEncoder = self.makeRenderCommandEncoder(descriptor: renderPass) else {
            fatalError("Could not create render encoder")
        }
        renderEncoder.setFrontFacing(.counterClockwise)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        
        for textureIndex in 0..<inputTextures.count {
            let currentTexture = inputTextures[UInt(textureIndex)]!
            
            let textureBuffer = sharedContext.device.makeBuffer(bytes: textureCoordinates,
                                                                length: textureCoordinates.count * MemoryLayout<Float>.size,
                                                                options: [])!
            renderEncoder.setVertexBuffer(textureBuffer, offset: 0, index: 1 + textureIndex)
            renderEncoder.setFragmentTexture(currentTexture.texture, index: textureIndex)
        }
        
        uniformSettings?.restoreShaderSettings(renderEncoder: renderEncoder)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: imageVertices.count / 2)
        renderEncoder.endEncoding()
    }
}

func generateRenderPipelineState(vertexFunctionName: String, fragmentFunctionName: String) -> MTLRenderPipelineState {
    guard let vertexFunction = sharedContext.defaultLibrary.makeFunction(name: vertexFunctionName) else {
        fatalError("Could not compile vertex function \(vertexFunctionName)")
    }
    
    guard let fragmentFunction = sharedContext.defaultLibrary.makeFunction(name: fragmentFunctionName) else {
        fatalError("Could not compile fragment function \(fragmentFunctionName)")
    }
    
    let descriptor = MTLRenderPipelineDescriptor()
    descriptor.colorAttachments[0].pixelFormat = MTLPixelFormat.bgra8Unorm
    descriptor.vertexFunction = vertexFunction
    descriptor.fragmentFunction = fragmentFunction
    
    do {
        return try sharedContext.device.makeRenderPipelineState(descriptor: descriptor)
    } catch {
        fatalError("Could not create render pipeline state for vertex:\(vertexFunctionName), fragment:\(fragmentFunctionName), error:\(error)")
    }
}
