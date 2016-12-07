//
//  CollectionViewController.swift
//  DTSImageExample
//
//  Created by Danny Sung on 12/02/2016.
//  Copyright © 2016 Sung Heroes LLC. All rights reserved.
//

import UIKit
import DTSImage

private let reuseIdentifier = "imageCell"

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        guard let originalImage = UIImage(named: "SmallImage") else { return }
        self.originalImage = originalImage

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.timerHandler()
        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.timer = nil
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        let imageCell = cell as! ImageCell
        self.setupImageCell(imageCell, cellForItemAt: indexPath)
        
        return cell
    }
    
    func setupImageCell(_ cell: ImageCell, cellForItemAt indexPath: IndexPath) {
        let backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Original Image"
            cell.imageView.image = self.originalImage
            cell.backgroundColor = backgroundColor
        case 1:
            cell.titleLabel.text = "RGBA8"
            cell.imageView.image = self.rgba8Image
            cell.backgroundColor = backgroundColor
        case 2:
            cell.titleLabel.text = "RGBAF"
            cell.imageView.image = self.rgbafImage
            cell.backgroundColor = backgroundColor
        case 3:
            cell.titleLabel.text = "RGBAF w/ mask"
            cell.imageView.image = self.rgbafImageWithMask
            cell.backgroundColor = backgroundColor
        default:
            cell.titleLabel.text = "(unknown)"
            cell.backgroundColor = UIColor.orange
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    // MARK: Private methods
    var originalImage: UIImage!
    var rgba8Image: UIImage?
    var rgbafImage: UIImage?
    var rgbafImageWithMask: UIImage?
    

    // A simple way to make changes, allowing for visual inspection of changes
    func timerHandler() {
        DispatchQueue.main.async {
            self.updateImages()
        }
    }
    
    var offset: Int = 0
    func updateImages() {
        guard let originalImage = self.originalImage else { return }
        self.rgba8Image = self.createRGBA8Image(offset: self.offset)?.toUIImage()
        
        if let rgbafImage = self.createRGBAFImage(offset: self.offset) {
            self.rgbafImage = rgbafImage.toUIImage()
            self.rgbafImageWithMask = self.createRGBAFImageWithMask(floatImage: rgbafImage,
                                                                    offset: self.offset).toUIImage()
        }
        self.collectionView!.reloadData()
        self.offset += 1
        if self.offset >= Int(originalImage.size.height/2) || self.offset >= Int(originalImage.size.width/2) {
            self.offset = 0
        }

    }


    // MARK: Image Generators
    func createRGBA8Image(offset: Int) -> DTSImageRGBA8? {
        guard let originalImage = self.originalImage else { return nil }
        guard var dtsImage = DTSImageRGBA8(image: originalImage) else { print("Error creating image"); return nil }
        
        let red = DTSPixelRGBA8(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        for y in 0..<dtsImage.height {
            dtsImage.setPixel(x: y - offset, y: y + offset, pixel: red)
        }
        
        return dtsImage
    }

    func createRGBAFImage(offset: Int) -> DTSImageRGBAF? {
        guard let originalImage = self.originalImage else { return nil }
        guard var dtsImage = DTSImageRGBAF(image: originalImage) else { print("Error creating image"); return nil }
        
        let blue = DTSPixelRGBAF(red: 0.2, green: 0.15, blue: 1.0, alpha: 1.0)
        
        dtsImage.setPixel(x: 0, y: 0, pixel: blue)
        dtsImage.setPixel(x: 1, y: 1, pixel: blue)
        for y in 0..<dtsImage.width {
            dtsImage.setPixel(x: y + offset, y: y - offset, pixel: blue)
        }

        return dtsImage
    }

    func createFloatMask(offset: Int, width: Int, height: Int) -> DTSImagePlanarF {
        var dtsImage = DTSImagePlanarF(width: width, height: height)
        
        let white = DTSPixelF(1)
        
        for x in width/10 ..< width * 9 / 10 {
            for y in 0..<30 {
                dtsImage.setPixel(x: x, y: y+offset, pixel: white)
            }
        }
        
        return dtsImage
    }
    func createRGBAFImageWithMask(floatImage: DTSImageRGBAF, offset: Int) -> DTSImageRGBAF {
        let mask = createFloatMask(offset: offset*2, width: floatImage.width, height: floatImage.height)
        
        let newImage = floatImage.apply(mask: mask)
        
        return newImage
    }
}
