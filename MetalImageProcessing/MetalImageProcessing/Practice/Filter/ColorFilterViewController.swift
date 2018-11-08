//
//  ColorFilterViewController.swift
//  MetalImageProcessing
//
//  Created by Colin on 2018/10/28.
//  Copyright © 2018年 Colin. All rights reserved.
//

import UIKit

class ColorFilterViewController: UIViewController {
    
    @IBOutlet weak var renderView: RenderView!
    
    var picture: PictureInput!
    var saturationFilter: SaturationFilter!
    var brightnessFilter: BrightnessFilter!
    var abaoFilter: LookupFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picture = PictureInput(image:UIImage(named:"image_3.jpg")!)
        
        saturationFilter = SaturationFilter.init()
        saturationFilter.saturation = 1.0
        
        brightnessFilter = BrightnessFilter.init()
        brightnessFilter.brightness = 0.0
        
        abaoFilter = LookupFilter.init()
        abaoFilter.lookupImage = PictureInput(image:UIImage(named:"lut_abao.png")!)
        abaoFilter.intensity = 0.0
        
        picture --> saturationFilter --> brightnessFilter --> abaoFilter --> renderView
        picture.processImage()
    }

    @IBAction func saturationDidChange(_ sender: UISlider) {
        saturationFilter.saturation = sender.value
        picture.processImage()
    }
    
    @IBAction func brightnessDidChange(_ sender: UISlider) {
        brightnessFilter.brightness = sender.value
        picture.processImage()
    }
    
    @IBAction func abaoIntensityDidChange(_ sender: UISlider) {
        abaoFilter.intensity = sender.value;
        picture.processImage()
    }
}
