//
//  DTSImagePlanarF.swift
//  Pods
//
//  Created by Danny Sung on 12/04/2016.
//
//

import Foundation

public struct DTSImagePlanarF: DTSImage {
    // MARK: Protocol Conformance
    public var pixels: [Float]
    static public var numberOfComponentsPerPixel: Int = 1
    public private(set) var width: Int
    public private(set) var height: Int
   
    public init?(image: UIImage) {
        print("TBD") // TODO: Needs implementation
        return nil
    }
    public init?(width: Int, height: Int, pixels: [Float]) {
        guard pixels.count >= width * height * DTSImagePlanarF.numberOfComponentsPerPixel else { return nil }
        self.pixels = pixels
        self.width = width
        self.height = height
    }
    public init(width: Int, height: Int) {
        let totalNumberOfComponents = width * height * DTSImagePlanarF.numberOfComponentsPerPixel
        var pixels = [Float].init(repeating: 0.0, count: totalNumberOfComponents)
        
        self.init(width: width, height: height, pixels: pixels)!
    }
    
    public func toUIImage() -> UIImage? {
        print("TBD") // TODO: Needs implementation
        return nil
    }

    public func getPixel(x: Int, y:Int) throws -> DTSPixelF {
        guard let offset = self.offset(x: x, y: y) else { throw DTSImageError.outOfRange }
        let components = [ self.pixels[offset] ]
        let pixel = DTSPixelF(components: components)!
        return pixel
    }
    public mutating func setPixel(x: Int, y:Int, pixel: DTSPixelF) {
        guard self.coordinateIsValid(x: x, y: y) else { return }
        let offset = (y * self.width + x) * DTSPixelF.numberOfComponentsPerPixel
        
        self.pixels[offset+0] = pixel.value
    }

}
