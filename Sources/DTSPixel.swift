//
//  DTSPixel.swift
//  Pods
//
//  Created by Danny Sung on 12/01/2016.
//
//

import Foundation

public protocol DTSPixel {
    associatedtype ComponentType
    init(red: Float, green: Float, blue: Float)
    init(red: Float, green: Float, blue: Float, alpha: Float)
    init?(components: [ComponentType])
    
    static var numberOfComponentsPerPixel: Int { get }
}

public extension DTSPixel {
    init(red: Float, green: Float, blue: Float) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    static func white() -> Self {
        return self.init(red: 1.0, green: 1.0, blue: 1.0)
    }
    static func black() -> Self {
        return self.init(red: 0.0, green: 0.0, blue: 0.0)
    }
}

