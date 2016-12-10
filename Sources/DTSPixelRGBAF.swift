//
//  DTSPixelRGBAF.swift
//  Pods
//
//  Created by Danny Sung on 12/02/2016.
//
//

import Foundation

/// A single pixel represented by 4 single-precision floating point numbers for each R, G, B, A values.
public struct DTSPixelRGBAF: DTSPixel, DTSPixelComponentArray {
    public static var bytesPerPixel: Int = MemoryLayout<Float>.size

    // MARK: Custom
    static let redOffset = 0
    static let greenOffset = 1
    static let blueOffset = 2
    static let alphaOffset = 3
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

    // MARK: DTSPixel Protocol
    public init() {
        self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.values = [red, green, blue, alpha]
    }

    // MARK: DTSPixelComponentArray Protocol
    public static var numberOfComponentsPerPixel: Int = 4
    public static var alphaPosition: DTSPixelComponentAlphaPosition = .last
    public static var componentMin: Float = 0.0
    public static var componentMax: Float = 1.0

    public var values: [Float]
}
