//
//  PictureInput.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/9/16.
//  Copyright © 2018年 Colin. All rights reserved.
//

import UIKit
import MetalKit

public class PictureInput: ImageSource {
    public let targets = TargetContainer()
    var internalTexture: Texture?
    var hasProcessedImage: Bool = false
    var internalImage: CGImage?
    
    public init(image: CGImage) {
        internalImage = image
    }
    
    public convenience init(image: UIImage) {
        self.init(image: image.cgImage!)
    }
    
    public convenience init(imageName: String) {
        guard let image = UIImage(named: imageName) else {
            fatalError("No such image named: \(imageName) in your application bundle")
        }
        self.init(image: image)
    }
    
    public func processImage(synchronously: Bool = false) {
        if let texture = internalTexture {
            if synchronously {
                updateTargetsWithTexture(texture)
                hasProcessedImage = true
            } else {
                DispatchQueue.global().async{
                    self.updateTargetsWithTexture(texture)
                    self.hasProcessedImage = true
                }
            }
        } else {
            let textureLoader = sharedContext.textureLoader
            if synchronously {
                do {
                    let imageTexture = try textureLoader.newTexture(cgImage: internalImage!, options: [MTKTextureLoader.Option.SRGB : false])
                    internalImage = nil
                    internalTexture = Texture(texture: imageTexture)
                    updateTargetsWithTexture(internalTexture!)
                    hasProcessedImage = true
                } catch {
                    fatalError("Failed loading image texture")
                }
            } else {
                textureLoader.newTexture(cgImage: internalImage!, options: [MTKTextureLoader.Option.SRGB : false], completionHandler: { (possibleTexture, error) in
                    guard (error == nil) else {
                        fatalError("Error in loading texture: \(error!)")
                    }
                    guard let texture = possibleTexture else {
                        fatalError("Nil texture received")
                    }
                    self.internalImage = nil
                    self.internalTexture = Texture(texture: texture)
                    DispatchQueue.global().async{
                        self.updateTargetsWithTexture(self.internalTexture!)
                        self.hasProcessedImage = true
                    }
                })
            }
        }
    }
    
    public func transmitPreviousImage(to target: ImageConsumer, atIndex: UInt) {
        if hasProcessedImage {
            target.newTextureAvailable(self.internalTexture!, fromSourceIndex: atIndex)
        }
    }
}
