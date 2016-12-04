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
    associatedtype PixelType
    associatedtype ComponentType
    
    var pixels: [ComponentType] { get set }
    
    var width: Int { get }
    var height: Int { get }
    var numPixels: Int { get }
    
    func coordinateIsValid(x:Int, y:Int) -> Bool

    init?(image: UIImage)
    init?(width: Int, height: Int, pixels: [ComponentType])

    func toUIImage() -> UIImage?
    
    func getPixel(x: Int, y:Int) throws -> PixelType
    mutating func setPixel(x: Int, y:Int, pixel: PixelType)

    static var numberOfComponentsPerPixel: Int { get }

    var numberOfPixelsPerImage: Int { get }
    var numberOfComponentsPerImage: Int { get }
    var numberOfComponentsPerRow: Int { get }
    var numberOfBytesPerRow: Int { get }
    
    static var numberOfBytesPerComponent: Int { get }
    static var numberOfBitsPerComponent: Int { get }
    static var numberOfBytesPerPixel: Int { get }
}

extension DTSImage {
    
    public func coordinateIsValid(x:Int, y:Int) -> Bool {
        guard x >= 0 else { return false }
        guard x < self.width else { return false }
        guard y >= 0 else { return false }
        guard y < self.height else { return false }
        
        return true
    }
    
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
