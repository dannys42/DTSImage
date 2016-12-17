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
    /// Generate a new image by applying a PlanarF mask to the current image
    ///
    /// The mask is applied to every component in the source image:
    ///         NewImage = self * mask
    ///
    /// The receiving image and the passed image *must* have the same dimensions.  The behavior is otherwise undefined.
    ///
    /// - Parameter mask: Planar Float
    /// - Returns: A new image in RGBAF format
    public func applying(mask: DTSImagePlanarF) -> DTSImageRGBAF {
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
    
    /// Create new image by multiplying receiver by the passed image
    ///
    /// result = self * image
    ///
    /// - Parameter image: image contents to multiply
    /// - Returns: A enw image in RGBAF format
    public func multiplying(image: DTSImageRGBAF) -> DTSImageRGBAF {
        var destImage = DTSImageRGBAF(width: self.width, height: self.height)
        destImage.pixels.withUnsafeMutableBufferPointer{ dstBufferPtr in
            let dstPixels = dstBufferPtr.baseAddress!
            let length = UInt(self.numberOfComponentsPerImage)
            
            vDSP_vmul(self.pixels, 1, image.pixels, 1,
                      dstPixels, 1,
                      length)
        }
        
        return destImage
    }
    
    /// Creates a new image that compares the vector distance between the receiving image and the given image.
    ///
    /// The receiving image and the passed image *must* have the same dimensions.  The behavior is otherwise undefined.
    ///
    /// result = (self - image)^2
    /// - Parameter image: an image to calculate the vector distance with
    /// - Returns: The resulting image to create
    public func calculatingDistanceSquared(image: DTSImageRGBAF) -> DTSImageRGBAF {
        var destImage = DTSImageRGBAF(width: self.width, height: self.height)

        destImage.pixels.withUnsafeMutableBufferPointer{ dstBufferPtr in
            let dstPixels = dstBufferPtr.baseAddress!
            let length = UInt(self.numberOfComponentsPerImage)
            
            vDSP_distancesq(self.pixels, 1, image.pixels, 1, dstPixels, length)
        }

        return destImage
    }
    
    /// Subtract the current image with contents of passed image
    ///
    /// Note: result = self - image
    ///
    /// - Parameter image: Image contents to subtract
    /// - Returns: resulting image
    public func subtracting(image: DTSImageRGBAF) -> DTSImageRGBAF {
        var destImage = DTSImageRGBAF(width: self.width, height: self.height)
                
        let minLength = min(self.numberOfComponentsPerImage, image.numberOfComponentsPerImage)
        let length = UInt(minLength)
        self.withUnsafePointerToComponents { inPixelsA in
            image.withUnsafePointerToComponents { inPixelsB in
                destImage.withUnsafeMutablePointerToComponents { dstPixels in
                    vDSP_vsub(inPixelsB, 1,
                              inPixelsA, 1,
                              dstPixels, 1,
                              length)
                }
            }
        }
        
        return destImage
    }
    

    /// Inverts the value of each component in an image.
    ///
    /// Note: result = 1.0 - self
    ///
    /// - Returns: Resulting image
    public func invertingValue() -> DTSImageRGBAF {
        let oneImage = DTSImageRGBAF(width: self.width, height: self.height, fill: .white)
        let dstImage = self.subtracting(image: oneImage)
        return dstImage
    }

}
