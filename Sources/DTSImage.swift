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

public protocol DTSImage {
    associatedtype PixelType: DTSPixel
    associatedtype ComponentType

    /* Things you should define */
    var pixels: [ComponentType] { get set }
    static var numberOfComponentsPerPixel: Int { get }

    var width: Int { get }
    var height: Int { get }
    
    init?(image: UIImage)
    init?(width: Int, height: Int, pixels: [ComponentType])
    init(width: Int, height: Int)

    func toUIImage() -> UIImage?
    func getPixel(x: Int, y:Int) throws -> PixelType
    mutating func setPixel(x: Int, y:Int, pixel: PixelType)
    
    /* Things that don't usually need to overriding */
    func coordinateIsValid(x:Int, y:Int) -> Bool
    var numPixels: Int { get }
}

extension DTSImage {
    public func offset(x:Int, y:Int) -> Int? {
        guard self.coordinateIsValid(x: x, y: y) else { return nil }
        let offset = (y * self.width + x) * PixelType.numberOfComponentsPerPixel

        return offset
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
    public var numberOfComponentsPerRow: Int {
        get {
            return self.width * Self.numberOfComponentsPerPixel
        }
    }
    public var numberOfBytesPerRow: Int {
        get {
            return self.numberOfComponentsPerRow * Self.numberOfBytesPerComponent
        }
    }
    public var numberOfComponentsPerImage: Int {
        get {
            return self.numberOfPixelsPerImage * self.numberOfComponentsPerRow
        }
    }

    static public var numberOfBytesPerComponent: Int {
        get {
            return MemoryLayout<Self.ComponentType>.size
        }
    }
    static public var numberOfBitsPerComponent: Int {
        get {
            return Self.numberOfBytesPerComponent*8
        }
    }
    static public var numberOfBytesPerPixel: Int {
        get {
            return Self.numberOfBytesPerComponent * self.numberOfComponentsPerPixel
        }
    }
}
