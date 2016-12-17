//
//  DTSImage.swift
//  Pods
//
//  Created by Danny Sung on 12/02/2016.
//
//

import Foundation

public enum DTSImageError: Error {
    case outOfRange
}

public enum DTSImageFillMethod {
    case black
    case white
    case value(Float)
}

public protocol DTSImage {
    associatedtype PixelType: DTSPixel


    var width: Int { get }
    var height: Int { get }
    
    init?(image: UIImage)
    init(width: Int, height: Int, fill: DTSImageFillMethod)

    func toUIImage() -> UIImage?
    func getPixel(x: Int, y:Int) throws -> PixelType
    mutating func setPixel(x: Int, y:Int, pixel: PixelType)
    
    /* Things that don't usually need to overriding */
    func coordinateIsValid(x:Int, y:Int) -> Bool
    var numPixels: Int { get }
}

public protocol DTSImageComponentArray: DTSImage {
    associatedtype ComponentType
    associatedtype PixelType: DTSPixelComponentArray

    /* Things you should define */
    static var numberOfComponentsPerPixel: Int { get }

    var pixels: [ComponentType] { get set }
    init?(width: Int, height: Int, pixels: [ComponentType])
}

extension DTSImageComponentArray where PixelType: DTSPixelComponentArray {
    static public var numberOfBytesPerComponent: Int {
        get {
            return MemoryLayout<Self.ComponentType>.size
        }
    }
    public func offset(x:Int, y:Int) -> Int? {
        guard self.coordinateIsValid(x: x, y: y) else { return nil }
        let offset = (y * self.width + x) * PixelType.numberOfComponentsPerPixel
        
        return offset
    }
    
    public var numberOfComponentsPerRow: Int {
        get {
            return self.width * Self.numberOfComponentsPerPixel
        }
    }
    public var numberOfComponentsPerImage: Int {
        get {
            return self.numberOfPixelsPerImage * Self.numberOfComponentsPerPixel
        }
    }
    
    /// Get a pointer to the pixel components start at the given row.
    ///
    /// Note: The block is not executed if the row given is out of range.
    ///
    /// - Parameters:
    ///   - row: must be between 0..<height
    ///   - block: Block to execute with the pointer
    public func withUnsafePointerToComponents(atRow row: Int = 0, block: ((UnsafePointer<ComponentType>) -> Void)) {
        guard row >= 0 && row < self.height else { return }
        let offset = row * self.numberOfComponentsPerRow
        self.pixels.withUnsafeBufferPointer { bufferPtr in
            let pixelsAtRow = bufferPtr.baseAddress!.advanced(by: offset)
            
            block(pixelsAtRow)
        }
    }
    /// Get a mutable pointer to the pixel components start at the given row.
    ///
    /// Note: The block is not executed if the row given is out of range.
    ///
    /// - Parameters:
    ///   - row: must be between 0..<height
    ///   - block: Block to execute with the pointer
    public mutating func withUnsafeMutablePointerToComponents(atRow row: Int = 0, block: ((UnsafeMutablePointer<ComponentType>) -> Void)) {
        guard row >= 0 && row < self.height else { return }
        let offset = row * self.numberOfComponentsPerRow
        self.pixels.withUnsafeMutableBufferPointer { bufferPtr in
            let pixelsAtRow = bufferPtr.baseAddress!.advanced(by: offset)
            
            block(pixelsAtRow)
        }
    }
}

extension DTSImage {
    public init(width: Float, height: Float, fill: DTSImageFillMethod) {
        self.init(width: Int(width), height: Int(height), fill: fill)
    }
    
    public func coordinateIsValid(x:Int, y:Int) -> Bool {
        guard x >= 0 else { return false }
        guard x < self.width else { return false }
        guard y >= 0 else { return false }
        guard y < self.height else { return false }
        
        return true
    }

    #if false // not sure why this doesn't work
    public func getPixel(x: Int, y:Int) throws -> PixelType {
        guard self.coordinateIsValid(x: x, y: y) else { throw DTSImageError.outOfRange }
        let offset = (y * self.width + x) * PixelType.numberOfComponentsPerPixel
        let components: [Self.ComponentType] = [
            self.pixels[offset+0],
            self.pixels[offset+1],
            self.pixels[offset+2],
            self.pixels[offset+3],
        ]
        let pixel = PixelType(components: components)
//        let pixel = DTSPixelRGBAF(red: self.pixels[offset+0],
//                                  green: self.pixels[offset+1],
//                                  blue: self.pixels[offset+2],
//                                  alpha: self.pixels[offset+3])

    }
    #endif

    public var numPixels: Int {
        get {
            return self.width * self.height
        }
    }
    
    public var numberOfPixelsPerImage: Int {
        get {
            return self.numPixels
        }
    }

}
