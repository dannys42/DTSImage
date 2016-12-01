//
//  DTSPixelRGBA8.swift
//  Pods
//
//  Created by Danny Sung on 12/01/2016.
//
//

import Foundation

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
    
    init(value: UInt32) {
        self.value = value
    }
    public init(red: Float, green: Float, blue: Float) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.value = 0x00
        self.red = UInt8(Int(red * 255))
        self.green = UInt8(Int(green * 255))
        self.blue = UInt8(Int(blue * 255))
        self.alpha = UInt8(Int(alpha * 255))
    }
    
}


extension DTSPixelRGBA8: Equatable {
    public static func ==(lhs:DTSPixelRGBA8, rhs:DTSPixelRGBA8) -> Bool {
        return lhs.value == rhs.value
    }
}
