//
//  DTSPixel.swift
//  Pods
//
//  Created by Danny Sung on 12/01/2016.
//
//

import Foundation

public protocol DTSPixel {
    init()
    init(red: Float, green: Float, blue: Float)
    init(red: Float, green: Float, blue: Float, alpha: Float)
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

/// A speical DTSPixel type that is composed of an array of ComponentTypes
public enum DTSPixelComponentAlphaPosition {
    case none
    case first
    case last
}

public protocol DTSPixelComponentArray: DTSPixel {
    associatedtype ComponentType
    var values: [ComponentType] { get set }
    init?(components: [ComponentType])
    
    static var alphaPosition: DTSPixelComponentAlphaPosition { get }
    static var numberOfComponentsPerPixel: Int { get }
    static var componentMin: ComponentType { get }
    static var componentMax: ComponentType { get }
}

extension DTSPixelComponentArray {
    public init?(components: [ComponentType]) {
        let newComponents: [ComponentType]
        
        switch Self.alphaPosition {
        case .none:
            newComponents = components
        case .first:
            if components.count < Self.numberOfComponentsPerPixel {
                newComponents = [Self.componentMax] + components
            } else {
                newComponents = components
            }
        case .last:
            if components.count < Self.numberOfComponentsPerPixel {
                newComponents = components + [Self.componentMax]
            } else {
                newComponents = components
            }
        }
        
        guard components.count >= Self.numberOfComponentsPerPixel else { return nil }

        var values: [ComponentType] = []
        for n in 0..<Self.numberOfComponentsPerPixel {
            values[n] = newComponents[n]
        }
        self.init()
        self.values = values
    }
}
