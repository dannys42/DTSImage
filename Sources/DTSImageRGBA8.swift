//
//  DTSImageRGBA8.swift
//  Pods
//
//  Created by Danny Sung on 12/01/2016.
//
//

import Foundation
import Accelerate

/// A Container to manage an image as raw 8-bit RGBA values
public struct DTSImageRGBA8: DTSImage {
    // MARK: DTSImage conformance
    public private(set) var width: Int
    public private(set) var height: Int
    
    public init(width: Int, height: Int, fill: DTSImageFillMethod) {
        let numBytes = width * height * DTSImageRGBA8.numberOfComponentsPerPixel
        let pixels: [UInt8]
        
        switch fill {
        case .black:
            pixels = [UInt8].init(repeating: UInt8.min, count: numBytes)
        case .white:
            pixels = [UInt8].init(repeating: UInt8.max, count: numBytes)
        case .value(let val):
            pixels = [UInt8].init(repeating: UInt8(val), count: numBytes)
        }
        
        self.init(width: width, height: height, pixels: pixels)!
    }

    public func getPixel(x: Int, y:Int) throws -> DTSPixelRGBA8 {
        guard self.coordinateIsValid(x: x, y: y) else { throw DTSImageError.outOfRange }
        let offset = (y * self.width + x) * DTSPixelRGBA8.numberOfComponentsPerPixel
        let pixel = DTSPixelRGBA8(red: self.pixels[offset+0],
                                  green: self.pixels[offset+1],
                                  blue: self.pixels[offset+2],
                                  alpha: self.pixels[offset+3])
        return pixel
    }
    public mutating func setPixel(x: Int, y:Int, pixel: DTSPixelRGBA8) {
        guard self.coordinateIsValid(x: x, y: y) else { return }
        let offset = (y * self.width + x) * DTSPixelRGBA8.numberOfComponentsPerPixel
        self.pixels[offset+0] = pixel.red
        self.pixels[offset+1] = pixel.green
        self.pixels[offset+2] = pixel.blue
        self.pixels[offset+3] = pixel.alpha
    }
    
    public init?(image: UIImage, scaleFactor: Float) {
        guard let cgImage = image.cgImage else { return nil }
        let outSize = CGSize(width: image.size.width * CGFloat(scaleFactor),
                             height: image.size.height * CGFloat(scaleFactor))

        let width = Int(outSize.width)
        let height = Int(outSize.height)
        let numPixels = width * height
        let numComponentsPerPixel = DTSImageRGBA8.numberOfComponentsPerPixel
        let totalNumberOfComponents = numPixels * numComponentsPerPixel
        self.width = width
        self.height = height
        let numBytesPerRow = width * DTSImageRGBA8.numberOfBytesPerPixel
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        let black = UInt8(0)
        var pixels = [UInt8](repeating: black, count: totalNumberOfComponents)
        let buffer = UnsafeMutableBufferPointer(start: &pixels, count: numPixels).baseAddress!
        guard let imageContext = CGContext(data: buffer,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: DTSImageRGBA8.numberOfBitsPerComponent,
                                           bytesPerRow: numBytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: bitmapInfo)
            else { return nil }
        
        imageContext.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: outSize))
        
        self.pixels = pixels
    }
    public func toUIImage() -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let destBytesPerRow = self.width * DTSPixelRGBA8.bytesPerPixel
        let destBitsPerComponent = 8
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        guard let imageContext = CGContext(data: nil,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: destBitsPerComponent,
                                           bytesPerRow: destBytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: bitmapInfo,
                                           releaseCallback: nil,
                                           releaseInfo: nil)
            else { return nil }
        
        guard let buffer = imageContext.data else { return nil }
        
        let pixels = buffer.bindMemory(to: DTSPixelRGBA8.self, capacity: self.numPixels)
        let totalNumberOfComponents = Int(self.numPixels * 4)
        memcpy(pixels, self.pixels, totalNumberOfComponents)
        
        guard let cgImage = imageContext.makeImage() else { return nil }
        
        let image = UIImage(cgImage: cgImage)
        return image
    }

    // MARK: DTSImageComponentArray conformance
    static public var numberOfComponentsPerPixel: Int = 4
    public var pixels: [UInt8]
    public init?(width: Int, height: Int, pixels: [UInt8]) {
        guard pixels.count >= width * height * DTSImageRGBA8.numberOfComponentsPerPixel else { return nil }
        
        self.width = width
        self.height = height
        self.pixels = pixels
    }

    // MARK: Custom methods
    static public let numberOfBytesPerComponent = 1
    static public var numberOfBitsPerComponent: Int = 8*numberOfBytesPerComponent
    static public var numberOfBytesPerPixel: Int = DTSImageRGBA8.numberOfBytesPerComponent * DTSImageRGBA8.numberOfComponentsPerPixel
    public var numberOfComponentsPerRow: Int {
        get {
            return DTSImageRGBA8.numberOfComponentsPerPixel * self.width
        }
    }
    public var numberOfBytesPerRow: Int {
        get {
            return self.numberOfComponentsPerRow * DTSImageRGBA8.numberOfBytesPerComponent
        }
    }

    // MARK: Protocol Conformance
    

    
    
    // MARK: Private methods
}
