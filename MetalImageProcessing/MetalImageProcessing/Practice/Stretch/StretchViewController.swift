//
//  StretchViewController.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/12/18.
//  Copyright © 2018年 Colin. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class StretchViewController: UIViewController {
    
    @IBOutlet weak var renderView: RenderView!
    
    var picture: PictureInput!
    var stretchFilter: StretchFilter!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        picture = PictureInput(image:UIImage(named:"image_5.jpg")!)
        stretchFilter = StretchFilter.init()
        
        picture --> stretchFilter --> renderView
        picture.processImage()
    }
    
    @IBAction func heightDidChange(_ sender: UISlider) {
        stretchFilter.heightFactor = sender.value
        picture.processImage()
    }
}
