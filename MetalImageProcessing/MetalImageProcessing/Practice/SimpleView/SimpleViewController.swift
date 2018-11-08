//
//  SimpleViewController.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/9/2.
//  Copyright © 2018年 Colin. All rights reserved.
//

import UIKit

class SimpleViewController: UIViewController {
    
    @IBOutlet var renderView: RenderView!
    
    var picture: PictureInput!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        picture = PictureInput(image:UIImage(named:"image_2.jpg")!)
        picture --> renderView
        picture.processImage()
    }
}
