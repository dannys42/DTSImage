//
//  DTSPixelF.swift
//  Pods
//
//  Created by Danny Sung on 12/04/2016.
//
//

import Foundation

public struct DTSPixelF: DTSPixel {
    public var value: Float
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
    
    static public var numberOfComponentsPerPixel: Int = 4
    
    init(value: Float) {
        self.value = value
    }
    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.value = max(red, green, blue, alpha)
    }
    public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let intVal = max(red, green, blue, alpha)
        self.value = Float(intVal) / Float(255)
    }
    public init?(components: [Float]) {
        guard components.count > 0 else { return nil }
        self.init(value: components[0])
    }

}
