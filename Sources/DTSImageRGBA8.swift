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
    public private(set) var pixels: [UInt8]

    // MARK: Protocol Conformance
    public private(set) var width: Int
    public private(set) var height: Int
    
    public func getPixel(x: Int, y:Int) throws -> DTSPixelRGBA8 {
        guard self.coordinateIsValid(x: x, y: y) else { throw DTSImageError.outOfRange }
        let offset = (y * self.width + x) * DTSPixelRGBA8.numberOfElementsPerPixel
        let pixel = DTSPixelRGBA8(red: self.pixels[offset+0],
                                  green: self.pixels[offset+1],
                                  blue: self.pixels[offset+2],
                                  alpha: self.pixels[offset+3])
        return pixel
    }
    public mutating func setPixel(x: Int, y:Int, pixel: DTSPixelRGBA8) {
        guard self.coordinateIsValid(x: x, y: y) else { return }
        let offset = (y * self.width + x) * DTSPixelRGBA8.numberOfElementsPerPixel
        self.pixels[offset+0] = pixel.red
        self.pixels[offset+1] = pixel.green
        self.pixels[offset+2] = pixel.blue
        self.pixels[offset+3] = pixel.alpha
    }
    public init?(image: UIImage) {
        guard let cgImage = image.cgImage else { return nil }

        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let numPixels = width * height
        let totalNumberOfComponents = numPixels * 4
        self.width = width
        self.height = height
        
        let bytesPerRow = width * DTSImageRGBA8.bytesPerPixel
        self.bytesPerRow = bytesPerRow
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue

        let black = UInt8(0)
        var pixels = [UInt8](repeating: black, count: totalNumberOfComponents)
        let buffer = UnsafeMutableBufferPointer(start: &pixels, count: numPixels).baseAddress!
        guard var imageContext = CGContext(data: buffer,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: DTSImageRGBA8.bitsPerComponent,
                                           bytesPerRow: bytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: bitmapInfo)
            else { return nil }
        imageContext.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: image.size))

        self.pixels = pixels
    }
    public init?(width: Int, height: Int, pixels: [UInt8]) {
        guard pixels.count >= width * height * 4 else { return nil }

        let bytesPerRow = width * DTSImageRGBA8.bytesPerPixel
        self.bytesPerRow = bytesPerRow
        self.width = width
        self.height = height
        self.pixels = pixels
    }
    public func toUIImage() -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        guard let imageContext = CGContext(data: nil,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: DTSImageRGBA8.bitsPerComponent,
                                           bytesPerRow: bytesPerRow,
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
    
    /*
    public func unsafeMutableBufferPointer() -> UnsafeMutableBufferPointer<Any> {
        let buffer = UnsafeMutableBufferPointer(start: &self.pixels, count: numPixels).baseAddress!

    }
    public func unsafePoitner() -> UnsafePointer {
        let inBuffer = UnsafeBufferPointer(start: rgb8Image.pixels, count: numPixels).baseAddress!

    }
 */
    
    // MARK: Private methods
    private static let bitsPerComponent = 8
    private static let bytesPerPixel = 4
    private static let bitsPerPixel = bytesPerPixel * 8
    private let bytesPerRow: Int
    
}
