//
//  YLZMetalView.swift
//  MetalDemo
//
//  Created by Colin on 2018/7/21.
//  Copyright © 2018年 Colin. All rights reserved.
//

import UIKit

class YLZMetalView: UIView {

    var device: MTLDevice!
    var commonQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!

    var metalLayer: CAMetalLayer {
        return layer as! CAMetalLayer
    }
    
    override class var layerClass : AnyClass {
        return CAMetalLayer.self
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }
    
    // MARK: - Private
    func commonInit() {
        device = MTLCreateSystemDefaultDevice()
        commonQueue = device?.makeCommandQueue()
        
        setupPipeline()
    }
    
    func setupPipeline() {
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "vertexShader")
        let fragmentFunction = library.makeFunction(name: "fragmentShader")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func render() {
        guard let drawable = metalLayer.nextDrawable() else {
            return
        }
        
        let renderPassDescripor = MTLRenderPassDescriptor()
        renderPassDescripor.colorAttachments[0].clearColor = MTLClearColorMake(0.48, 0.74, 0.92, 1)
        renderPassDescripor.colorAttachments[0].texture = drawable.texture
        renderPassDescripor.colorAttachments[0].loadAction = .clear
        renderPassDescripor.colorAttachments[0].storeAction = .store
        
        let commandBuffer = commonQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescripor)!
        
        commandEncoder.setRenderPipelineState(pipelineState)
        let vertices = [YLZVertex(position: [ 0.5, -0.5], color: [1, 0, 0, 1]),
                        YLZVertex(position: [-0.5, -0.5], color: [0, 1, 0, 1]),
                        YLZVertex(position: [ 0.0,  0.5], color: [0, 0, 1, 1])]
        if #available(iOS 8.3, *) {
            commandEncoder.setVertexBytes(vertices, length: MemoryLayout<YLZVertex>.size * 3, index: Int(YLZVertexInputIndexVertices.rawValue))
        } else {
            // Fallback on earlier versions
        }
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
