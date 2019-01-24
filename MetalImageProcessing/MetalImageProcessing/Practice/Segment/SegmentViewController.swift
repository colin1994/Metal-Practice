//
//  SegmentViewController.swift
//  MetalImageProcessing
//
//  Created by Colin on 2019/1/13.
//  Copyright © 2019 Colin. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class SegmentViewController: UIViewController {
    
    @IBOutlet weak var renderView: RenderView!
    
    var picture: PictureInput!
    var mask: PictureInput!
    var material: PictureInput!
    var segmentFilter: SegmentFilter!
    var index = 0
    
    let materials = ["material_0.jpg",
                     "material_1.jpg",
                     "material_2.jpg",
                     "material_3.jpg",
                     "material_4.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage.init(named: "image_7.jpg")!
        picture = PictureInput(image: image)

        let maskImage = image.segmentation()!
        mask = PictureInput(image: maskImage)
        
        material = PictureInput(imageName: materials.first!)
        
        segmentFilter = SegmentFilter.init()
        segmentFilter.maskImage = mask
        segmentFilter.materialImage = material
        
        picture --> segmentFilter --> renderView
        picture.processImage()
    }

    @IBAction func alphaDidChange(_ sender: UISlider) {
        segmentFilter.alpha = sender.value
        picture.processImage()
    }
    
    @IBAction func actionChange(_ sender: UIButton) {
        index = index + 1
        if index >= materials.count {
            index = 0
        }
        
        material = PictureInput(imageName: materials[index])
        segmentFilter.materialImage = material
        picture.processImage()
    }
}
