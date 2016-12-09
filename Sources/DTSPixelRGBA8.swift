//
//  DTSPixelRGBA8.swift
//  Pods
//
//  Created by Danny Sung on 12/01/2016.
//
//

import Foundation

/// A single pixel represented by 8-bit R, G, B, A values.
/// Where R is the most significant byte, and A is the least signifanct.
public struct DTSPixelRGBA8: DTSPixel {
    public var value: UInt32
    public var red: UInt8 {
        get { return UInt8(value & 0xFF) }
        set { value = UInt32(newValue) | (value & 0xFFFFFF00) }
    }
    public var green: UInt8 {
        get { return UInt8((value >> 8) & 0xFF) }
        set { value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF) }
    }
    public var blue: UInt8 {
        get { return UInt8((value >> 16) & 0xFF) }
        set { value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF) }
    }
    public var alpha: UInt8 {
        get { return UInt8((value >> 24) & 0xFF) }
        set { value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF) }
    }
    
    static public var bytesPerPixel: Int = MemoryLayout<UInt32>.size
    static public var numberOfComponentsPerPixel: Int = 4
    
    public init() {
        self.init(value: 0)
    }
    public init(value: UInt32) {
        self.value = value
    }
    public init?(components: [UInt8]) {
        guard components.count > 3 else { return nil }
        let alpha: UInt8
        if components.count > 3 {
            alpha = components[3]
        } else {
            alpha = UInt8.max
        }
        self.init(red: components[0], green: components[1], blue: components[2], alpha: alpha)
    }
    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.value = 0x00
        let uintMax = Float(UInt8.max)
        self.red = UInt8(Int(red * uintMax))
        self.green = UInt8(Int(green * uintMax))
        self.blue = UInt8(Int(blue * uintMax))
        self.alpha = UInt8(Int(alpha * uintMax))
    }
    public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.value = 0x00
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
}


extension DTSPixelRGBA8: Equatable {
    public static func ==(lhs:DTSPixelRGBA8, rhs:DTSPixelRGBA8) -> Bool {
        return lhs.value == rhs.value
    }
}
