//
//  DTSImageRGBAF+Algorithms.swift
//  Pods
//
//  Created by Danny Sung on 12/04/2016.
//
//

import Foundation
import Accelerate

public extension DTSImageRGBAF {
    /// Apply a mask to an image, generating a new image.
    ///
    /// The mask is applied to every component in the source image:
    ///         NewImage = self * mask
    ///
    /// - Parameter mask: Planar Float
    /// - Returns: A new image in RGBAF format
    func apply(mask: DTSImagePlanarF) -> DTSImageRGBAF {
        var destImage = DTSImageRGBAF(width: self.width, height: self.height)
        
        for componentNdx in 0..<DTSImageRGBAF.numberOfComponentsPerPixel {
            self.pixels.withUnsafeBufferPointer{ srcBufferPtr in
                let srcPixels = srcBufferPtr.baseAddress!.advanced(by: componentNdx)
                
                destImage.pixels.withUnsafeMutableBufferPointer{ dstBufferPtr in
                    let dstPixels = dstBufferPtr.baseAddress!.advanced(by: componentNdx)
                    
                    vDSP_vmul(srcPixels, DTSImageRGBAF.numberOfComponentsPerPixel,
                              mask.pixels, 1,
                              dstPixels, DTSImageRGBAF.numberOfComponentsPerPixel,
                              UInt(self.numPixels))
                }
            }
        }
        return destImage
    }
}
