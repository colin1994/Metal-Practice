//
//  StyleTransferViewController.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/12/16.
//  Copyright © 2018 Colin. All rights reserved.
//

import UIKit
import CoreML

@available(iOS 11.0, *)
class StyleTransferViewController: UIViewController {
    let imageSize = 720
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var inputImage = UIImage(named: "input")!
    
    private let models = [
        mosaic().model,
        the_scream().model,
        udnie().model,
        candy().model
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.alpha = 0
        
        for btn in buttons {
            btn.imageView?.contentMode = .scaleAspectFill
        }
    }
    
    // MARK: - Action
    @IBAction func styleButtonTouched(_ sender: UIButton) {
        guard let image = inputImage.scaled(to: CGSize(width: imageSize, height: imageSize), scalingMode: .aspectFit).cgImage else {
            print("Could not get a CGImage")
            return
        }
        
        let model = models[sender.tag]
        
        toggleLoading(show: true)
        
        DispatchQueue.global(qos: .userInteractive).async {
            let stylized = self.stylizeImage(cgImage: image, model: model)
            
            DispatchQueue.main.async {
                self.toggleLoading(show: false)
                self.imageView.image = UIImage(cgImage: stylized)
            }
        }
    }
    
    // MARK: - Processing
    private func stylizeImage(cgImage: CGImage, model: MLModel) -> CGImage {
        let input = StyleTransferInput(input: pixelBuffer(cgImage: cgImage, width: imageSize, height: imageSize))
        let outFeatures = try! model.prediction(from: input)
        let output = outFeatures.featureValue(for: "outputImage")!.imageBufferValue!
        CVPixelBufferLockBaseAddress(output, .readOnly)
        let width = CVPixelBufferGetWidth(output)
        let height = CVPixelBufferGetHeight(output)
        let data = CVPixelBufferGetBaseAddress(output)!
        
        let outContext = CGContext(data: data,
                                   width: width,
                                   height: height,
                                   bitsPerComponent: 8,
                                   bytesPerRow: CVPixelBufferGetBytesPerRow(output),
                                   space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: CGImageByteOrderInfo.order32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)!
        let outImage = outContext.makeImage()!
        CVPixelBufferUnlockBaseAddress(output, .readOnly)
        
        return outImage
    }
    
    private func pixelBuffer(cgImage: CGImage, width: Int, height: Int) -> CVPixelBuffer {
        var pixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
        if status != kCVReturnSuccess {
            fatalError("Cannot create pixel buffer for image")
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)
        let context = CGContext(data: data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer!
    }
    
    // MARK: - Animation
    private func toggleLoading(show: Bool) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            if show {
                self?.loadingView.alpha = 0.85
            } else {
                self?.loadingView.alpha = 0
            }
        }
    }
}


