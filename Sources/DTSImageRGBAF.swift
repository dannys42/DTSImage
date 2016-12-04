//
//  DTSImageRGBAF.swift
//  Pods
//
//  Created by Danny Sung on 12/02/2016.
//
//

import Foundation
import Accelerate

/// A Container to manage an image as an array of single precision floating point numbers
public struct DTSImageRGBAF: DTSImage {
    public private(set) var pixels: [Float]
    // MARK: Protocol Conformance
    public private(set) var width: Int
    public private(set) var height: Int
    
    public init?(image: UIImage) {
        guard let rgb8Image = DTSImageRGBA8(image: image) else { return nil }
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        
        let numPixels = rgb8Image.numPixels
        let black = Float(0)
        let totalNumberOfComponents = numPixels * 4
        var pixels = [Float](repeating: black, count: totalNumberOfComponents)
        
        let numTotalComponents = numPixels * 4
        
        let inBuffer = UnsafeBufferPointer(start: rgb8Image.pixels, count: numPixels).baseAddress!
        let outBuffer = UnsafeMutableBufferPointer(start: &pixels, count: numPixels).baseAddress!
        
        let background8 = DTSPixelRGBA8(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.0)
        var inTestPixels = [DTSPixelRGBA8](repeating: background8, count: numPixels)
        let inTestBuffer = UnsafeMutableBufferPointer(start: &inTestPixels, count: numPixels).baseAddress!

        
        inBuffer.withMemoryRebound(to: UInt8.self, capacity: numTotalComponents) { inPixels in
            // This Results in floating point values up from 0..255
            vDSP_vfltu8(inPixels, 1, &pixels, 1, UInt(numTotalComponents))
        }
        // Normalize all pixels to range from 0..1
        var value = Float(255)
        vDSP_vsdiv(&pixels, 1, &value, &pixels, 1, UInt(numTotalComponents))

        #if false
        rgb8Image.pixels.withUnsafeBufferPointer { inputPixelPtr in
            inputPixelPtr.baseAddress!.withMemoryRebound(to: Int8.self, capacity: numPixels*4) { inputIntPtr in
                let inPixels = UnsafePointer<Int8>(inputIntPtr)

                pixels.withUnsafeMutableBufferPointer { outputPixelPtr in
                    print("outputPixelPtr:  \(outputPixelPtr)  base: \(outputPixelPtr.baseAddress)")
                    outputPixelPtr.baseAddress!.withMemoryRebound(to: Float.self, capacity: numPixels*4) { outputFloatPtr in
                        let outPixels = UnsafeMutablePointer<Float>(outputFloatPtr)

                        print("outputPixelPtr:  \(outputPixelPtr)  base: \(outputPixelPtr.baseAddress)")
                        print("outputFloatPtr:  \(outputFloatPtr)")
                        print("outPixels:  \(outPixels)")
                        
                        vDSP_vflt8(inPixels, 1, outPixels, 1, UInt(numTotalComponents))
                    }
                }
            }
        }
        #endif
        
        self.pixels = pixels
        self.width = width
        self.height = height
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
        
        let outPixels = buffer.bindMemory(to: UInt8.self, capacity: self.numPixels)
        let totalNumberOfComponents = UInt(self.numPixels * 4)
        
        // Store a temporary array that takes the 0..1 float values, multiply by max UInt8 (255)
        // then convert to integer
        var floatPixels: [Float] = self.pixels
        var multiplyValue = Float(255)
        vDSP_vsmul(self.pixels, 1, &multiplyValue, &floatPixels, 1, totalNumberOfComponents)
        vDSP_vfixu8(floatPixels, 1, outPixels, 1, totalNumberOfComponents)
        
        guard let cgImage = imageContext.makeImage() else { return nil }
        let image = UIImage(cgImage: cgImage)
        return image
    }
    
    public func getPixel(x: Int, y:Int) throws -> DTSPixelRGBAF {
        guard self.coordinateIsValid(x: x, y: y) else { throw DTSImageError.outOfRange }
        let offset = (y * self.width + x) * DTSPixelRGBAF.numberOfElementsPerPixel
        let pixel = DTSPixelRGBAF(red: self.pixels[offset+0],
                                  green: self.pixels[offset+1],
                                  blue: self.pixels[offset+2],
                                  alpha: self.pixels[offset+3])
        return pixel
    }
    public mutating func setPixel(x: Int, y:Int, pixel: DTSPixelRGBAF) {
        guard self.coordinateIsValid(x: x, y: y) else { return }
        let offset = (y * self.width + x) * DTSPixelRGBAF.numberOfElementsPerPixel
        self.pixels[offset+0] = pixel.red
        self.pixels[offset+1] = pixel.green
        self.pixels[offset+2] = pixel.blue
        self.pixels[offset+3] = pixel.alpha
    }

    // MARK: Private Methods
}