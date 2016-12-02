//
//  DTSImageRGBA8.swift
//  Pods
//
//  Created by Danny Sung on 12/01/2016.
//
//

import Foundation

public struct DTSImageRGBA8 {
    public private(set) var pixels: [DTSPixelRGBA8]
    public private(set) var width: Int
    public private(set) var height: Int
    
    private static let bitsPerComponent = 8
    private static let bytesPerPixel = 4
    private static let bitsPerPixel = bytesPerPixel * 8
    private let bytesPerRow: Int
    
    public enum imageError: Error {
        case outOfRange
    }
    public func numPixels() -> Int {
        return width * height
    }
    
    public func coordinateIsValid(x:Int, y:Int) -> Bool {
        guard x >= 0 else { return false }
        guard x < self.width else { return false }
        guard y >= 0 else { return false }
        guard y < self.height else { return false }
        
        return true
    }
    public func getPixel(x: Int, y:Int) throws -> DTSPixelRGBA8 {
        guard self.coordinateIsValid(x: x, y: y) else { throw imageError.outOfRange }
        return self.pixels[width * y + x]
    }
    public mutating func setPixel(x: Int, y:Int, pixel: DTSPixelRGBA8) throws {
        guard self.coordinateIsValid(x: x, y: y) else { throw imageError.outOfRange }
        self.pixels[width * y + x] = pixel
    }
    public init?(image: UIImage) {
        guard let cgImage = image.cgImage else { return nil }

        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let numPixels = width * height
        self.width = width
        self.height = height
        
        let bytesPerRow = width * DTSImageRGBA8.bytesPerPixel
        self.bytesPerRow = bytesPerRow
        let black = DTSPixelRGBA8(red: 0.25, green: 0.25, blue: 0.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue

        var pixels = [DTSPixelRGBA8](repeating: black, count: numPixels)
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
        
        let pixels = buffer.bindMemory(to: DTSPixelRGBA8.self, capacity: self.numPixels())
        for row in 0 ..< height {
            for col in 0 ..< width {
                let offset = row * self.width + col
                pixels[offset] = self.pixels[offset]
            }
        }
        
        guard let cgImage = imageContext.makeImage() else { return nil }
        
        let image = UIImage(cgImage: cgImage)
        return image
    }
}
