//
//  ZoomBlurViewController.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/11/27.
//  Copyright © 2018 Colin. All rights reserved.
//

import UIKit

class ZoomBlurViewController: UIViewController {
    
    @IBOutlet weak var renderView: RenderView!
    
    var picture: PictureInput!
    var zoomBlur: ZoomBlur!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        picture = PictureInput(image:UIImage(named:"image_4.jpg")!)
        
        zoomBlur = ZoomBlur.init()
        zoomBlur.blurSize = 0.0
        
        picture --> zoomBlur --> renderView
        picture.processImage()
    }
    
    @IBAction func sizeDidChange(_ sender: UISlider) {
        zoomBlur.blurSize = sender.value
        picture.processImage()
    }
}
