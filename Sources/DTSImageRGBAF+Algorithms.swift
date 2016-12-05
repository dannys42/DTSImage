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
    // apply mask to generate image
    
    func apply(mask: DTSImagePlanarF) -> DTSImageRGBAF {
        var dstImage = DTSImageRGBAF(width: self.width, height: self.height)
        vDSP_vcmprs(self.pixels, DTSImageRGBAF.numberOfComponentsPerPixel,
                    mask.pixels, 1,
                    &dstImage.pixels, DTSImageRGBAF.numberOfComponentsPerPixel,
                    UInt(self.numPixels))
        
        return dstImage
    }
}
