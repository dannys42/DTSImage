//
//  DTSPixelRGBAF.swift
//  Pods
//
//  Created by Danny Sung on 12/02/2016.
//
//

import Foundation

/// A single pixel represented by 4 single-precision floating point numbers for each R, G, B, A values.
public struct DTSPixelRGBAF: DTSPixel {
    static let redOffset = 0
    static let greenOffset = 1
    static let blueOffset = 2
    static let alphaOffset = 3
    
    public var values: [Float]
    public var red: Float {
        get {
            return values[DTSPixelRGBAF.redOffset]
        }
        set {
            values[DTSPixelRGBAF.redOffset] = red
        }
    }
    public var green: Float {
        get {
            return values[DTSPixelRGBAF.greenOffset]
        }
        set {
            values[DTSPixelRGBAF.greenOffset] = green
        }
    }
    public var blue: Float {
        get {
            return values[DTSPixelRGBAF.blueOffset]
        }
        set {
            values[DTSPixelRGBAF.blueOffset] = blue
        }
    }
    public var alpha: Float {
        get {
            return values[DTSPixelRGBAF.alphaOffset]
        }
        set {
            values[DTSPixelRGBAF.alphaOffset] = alpha
        }
    }
    static public var bytesPerPixel: Int = MemoryLayout<Float>.size
    static public var numberOfComponentsPerPixel: Int = 4

    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.values = [red, green, blue, alpha]
    }
    public init?(components: [Float]) {
        guard components.count > 3 else { return nil }
        let alpha: Float
        if components.count > 3 {
            alpha = components[3]
        } else {
            alpha = Float(1.0)
        }
        self.init(red: components[0], green: components[1], blue: components[2], alpha: alpha)
    }
}
