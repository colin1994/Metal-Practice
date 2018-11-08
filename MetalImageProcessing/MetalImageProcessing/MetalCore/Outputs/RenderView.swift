//
//  RenderView.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/9/2.
//  Copyright © 2018年 Colin. All rights reserved.
//

import Foundation
import MetalKit

public class RenderView: UIView {
    public let sources = SourceContainer()
    public let maximumInputs: UInt = 1
    
    public var clearColor = RenderColor.clearColor
    
    public var fillMode = FillMode.preserveAspectRatio
    
    var currentTexture: Texture?
    var renderPipelineState: MTLRenderPipelineState!
    
    lazy var metalView: MTKView = {
        let metalView = MTKView.init(frame: self.bounds, device: sharedContext.device)
        metalView.isPaused = true

        return metalView
    }()
    
    // MARK: -
    // MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        renderPipelineState = generateRenderPipelineState(vertexFunctionName: FunctionName.OneInputVertex,
                                                          fragmentFunctionName: FunctionName.PassthroughFragment)

        metalView.delegate = self
        addSubview(metalView)
    }
}

// MARK: -
// MARK: ImageConsumer
extension RenderView: ImageConsumer {
    
    public func newTextureAvailable(_ texture: Texture, fromSourceIndex: UInt) {
        currentTexture = texture
        
        metalView.draw()
    }
}

// MARK: -
// MARK: MTKViewDelegate
extension RenderView: MTKViewDelegate {
    
    public func draw(in view: MTKView) {
        guard let currentDrawable = self.metalView.currentDrawable,
              let imageTexture = currentTexture else {
                debugPrint("Warning: Could update Current Drawable")
                return
        }
        
        let outputTexture = Texture(texture: currentDrawable.texture)
        let scaledVertices = fillMode.transformVertices(verticallyInvertedImageVertices, fromInputSize:CGSize(width: imageTexture.texture.width, height: imageTexture.texture.height), toFitSize:metalView.drawableSize)

        let commandBuffer = sharedContext.commandQueue.makeCommandBuffer()!
        commandBuffer.renderQuad(pipelineState: renderPipelineState, inputTextures: [0:imageTexture], outputTexture: outputTexture, clearColor:clearColor, imageVertices: scaledVertices)
        
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
}
