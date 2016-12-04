//
//  ViewController.swift
//  DTSImageExample
//
//  Created by Danny Sung on 12/01/2016.
//  Copyright © 2016 Sung Heroes LLC. All rights reserved.
//

import UIKit
import DTSImage

class ViewController: UIViewController {
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var updateImageView: UIImageView!
    var originalImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.originalImageView.image = self.originalImage
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let originalImage = UIImage(named: "SmallImage") else { return }
        self.originalImage = originalImage
        
        
        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    
    var offset: Int = 0
    func timerHandler() {
        guard let originalImage = self.originalImage else { return }
        DispatchQueue.main.async {
            self.createUpdateImage(offset: self.offset)
        }
        self.offset += 1
        if self.offset >= Int(originalImage.size.height/2) || self.offset >= Int(originalImage.size.width/2) {
            self.offset = 0
        }
    }
    
    func createUpdateImage(offset: Int) {
        guard let originalImage = self.originalImage else { return }
        guard var dtsImage = DTSImageRGBA8(image: originalImage) else { print("Error creating image"); return }
        
        let red = DTSPixelRGBA8(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        for y in 0..<dtsImage.height {
            dtsImage.setPixel(x: y - offset, y: y + offset, pixel: red)
        }
        
        let newImage = dtsImage.toUIImage()
        
        self.updateImageView.image = newImage
    }

}

