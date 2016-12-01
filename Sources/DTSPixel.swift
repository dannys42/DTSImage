//
//  DTSPixel.swift
//  Pods
//
//  Created by Danny Sung on 12/01/2016.
//
//

import Foundation

public protocol DTSPixel {
    init(red: Float, green: Float, blue: Float)
}

public extension DTSPixel {
    static func white() -> Self {
        return self.init(red: 1.0, green: 1.0, blue: 1.0)
    }
    static func black() -> Self {
        return self.init(red: 0.0, green: 0.0, blue: 0.0)
    }
}

