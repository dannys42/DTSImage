//
//  DTSPixelF.swift
//  Pods
//
//  Created by Danny Sung on 12/04/2016.
//
//

import Foundation

public struct DTSPixelF: DTSPixel, DTSPixelComponentArray {
    // MARK: DTSPixel Conformance
    
    public init() {
        self.init(0.0)
    }
    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        let value = max(red, green, blue, alpha)
        self.init(value)
    }
    public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let intVal = max(red, green, blue, alpha)
        let value = Float(intVal) / Float(255)
        self.init(value)
    }

    // MARK: DTSPixelComponentArray Conformance
    public var values: [Float]
    public static var alphaPosition: DTSPixelComponentAlphaPosition = .none
    public static var numberOfComponentsPerPixel: Int = 1
    public static var componentMin: Float = 0
    public static var componentMax: Float = 1
    
    // MARK: Custom
    
    public var value: Float {
        get {
            return values[0]
        }
        set {
            values[0] = newValue
        }
    }
    public var red: Float {
        get { return self.value }
        set { self.value = red }
    }
    public var green: Float {
        get { return self.value }
        set { self.value = green }
    }
    public var blue: Float {
        get { return self.value }
        set { self.value = blue }
    }
    public var alpha: Float {
        get { return self.value }
        set { self.value = alpha }
    }
    
    public init(_ value: Float) {
        self.values = [ value ]
    }
}
