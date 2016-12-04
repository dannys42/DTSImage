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
    var width: Int { get }
    var height: Int { get }
    var numPixels: Int { get }
    
    func coordinateIsValid(x:Int, y:Int) -> Bool

    init?(image: UIImage)
    func toUIImage() -> UIImage?
    
    func getPixel(x: Int, y:Int) throws -> PixelType
    mutating func setPixel(x: Int, y:Int, pixel: PixelType)
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
            return width * height
        }
    }
}
