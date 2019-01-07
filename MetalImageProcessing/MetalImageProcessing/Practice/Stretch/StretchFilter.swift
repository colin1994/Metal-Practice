//
//  StretchFilter.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/12/19.
//  Copyright © 2018 Colin. All rights reserved.
//

import Foundation
import Metal

@available(iOS 10.0, *)
public class StretchFilter: BasicOperation {
    
    public var heightFactor: Float =  1.0;
    public var texCoordBeginY: Float = 0.6;
    public var texCoordEndY: Float = 0.8;
    var textureHeap: MTLHeap?
    public init() {
        super.init(fragmentFunctionName:FunctionName.PassthroughFragment, numberOfInputs:1)
    }
    
    public override func newTextureAvailable(_ texture: Texture, fromSourceIndex: UInt) {
        let _ = textureInputSemaphore.wait(timeout:DispatchTime.distantFuture)
        defer {
            textureInputSemaphore.signal()
        }
        
        inputTextures[fromSourceIndex] = texture
        
        if (UInt(inputTextures.count) >= maximumInputs) {
            let scaleHeightFactor: Float = (texCoordEndY - texCoordBeginY) * (heightFactor - 1.0) + 1.0;
            let verticesBeginY: Float = texCoordBeginY / scaleHeightFactor
            let verticesEndY: Float = (texCoordBeginY + (texCoordEndY - texCoordBeginY) * heightFactor) / scaleHeightFactor
            
            let imageVertices: [Float] = [-1.0, 1.0, 1.0, 1.0,
                                          -1.0, -2.0 * verticesBeginY + 1.0, 1.0, -2.0 * verticesBeginY + 1.0,
                                          -1.0, -2.0 * verticesEndY + 1.0, 1.0, -2.0 * verticesEndY + 1.0,
                                          -1.0, -1.0, 1.0, -1.0]

            let textureCoordinates: [Float] = [0.0, 0.0, 1.0, 0.0,
                                               0.0, texCoordBeginY, 1.0, texCoordBeginY,
                                               0.0, texCoordEndY, 1.0, texCoordEndY,
                                               0.0, 1.0, 1.0, 1.0]
            
            let outputWidth: Int
            var outputHeight: Int
            
            let firstInputTexture = inputTextures[0]!
            outputWidth = firstInputTexture.texture.width
            outputHeight = Int(Float(firstInputTexture.texture.height) * scaleHeightFactor)
            
            guard let commandBuffer = sharedContext.commandQueue.makeCommandBuffer() else {
                return
            }
            
            var outputTexture: Texture
            let useHeap = true
            if useHeap {
                // 通过 MTLHeap 创建 MTLTexture ----------
                if textureHeap == nil {
                    let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                                     width: firstInputTexture.texture.width,
                                                                                     height: Int(Float(firstInputTexture.texture.height) * ((texCoordEndY - texCoordBeginY) * (1.5 - 1.0) + 1.0)),
                                                                                     mipmapped: false)
                    textureDescriptor.usage = [.renderTarget, .shaderRead, .shaderWrite]
                    
                    let sizeAndAlign = sharedContext.device.heapTextureSizeAndAlign(descriptor: textureDescriptor)
                    let heapDescriptor = MTLHeapDescriptor()
                    heapDescriptor.cpuCacheMode = .defaultCache
                    heapDescriptor.storageMode = .shared
                    heapDescriptor.size = sizeAndAlign.size
                    
                    textureHeap = sharedContext.device.makeHeap(descriptor: heapDescriptor)
                }
                
                let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                                 width: outputWidth,
                                                                                 height: outputHeight,
                                                                                 mipmapped: false)
                textureDescriptor.usage = [.renderTarget, .shaderRead, .shaderWrite]
                guard let newTexture = textureHeap?.makeTexture(descriptor: textureDescriptor) else {
                    return
                }
                newTexture.makeAliasable()
                outputTexture = Texture.init(texture: newTexture)
            } else {
                if #available(iOS 11.0, *) {
                    print("memory: " + String(sharedContext.device.currentAllocatedSize))
                } else {
                    // Fallback on earlier versions
                }
                outputTexture = Texture(width: outputWidth, height: outputHeight)
            }

            commandBuffer.renderQuad(pipelineState: renderPipelineState, uniformSettings: uniformSettings, inputTextures: inputTextures, outputTexture: outputTexture, clearColor: RenderColor.clearColor, imageVertices: imageVertices, textureCoordinates: textureCoordinates)
            commandBuffer.commit()
            
            updateTargetsWithTexture(outputTexture)
        }
    }
}
