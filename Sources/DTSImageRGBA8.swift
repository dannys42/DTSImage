//
//  DTSImageRGBA8.swift
//  Pods
//
//  Created by Danny Sung on 12/01/2016.
//
//

import Foundation

struct DTSImageRGBA8 {
    public private(set) var pixels: [DTSPixelRGBA8]
    public private(set) var width: Int
    public private(set) var height: Int
    
    private static let bitsPerComponent = 8
    private static let bytesPerPixel = 4
    private static let bitsPerPixel = bytesPerPixel * 8
    private let bytesPerRow: Int
    
    func numPixels() -> Int {
        return width * height
    }
    func value(x: Int, y: Int) -> DTSPixelRGBA8 {
        return self.pixels[width * y + x]
    }
    init?(image: UIImage) {
        guard let cgImage = image.cgImage else { return nil }
        
        self.width = Int(image.size.width)
        self.height = Int(image.size.height)
        
        self.bytesPerRow = width * DTSImageRGBA8.bytesPerPixel
        let black = DTSPixelRGBA8.black()
        self.pixels = [DTSPixelRGBA8](repeating: black, count: width * height)
        let imageData = UnsafeMutablePointer<DTSPixelRGBA8>.allocate(capacity: width * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        guard let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: DTSImageRGBA8.bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
            else { return nil }
        imageContext.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: image.size))
    }
    func toUIImage() -> UIImage? {
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
