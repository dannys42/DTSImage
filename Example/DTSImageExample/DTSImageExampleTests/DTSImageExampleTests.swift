//
//  DTSImageExampleTests.swift
//  DTSImageExampleTests
//
//  Created by Danny Sung on 12/01/2016.
//  Copyright © 2016 Sung Heroes LLC. All rights reserved.
//

import XCTest
import DTSImage
@testable import DTSImageExample

class DTSImageExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func smallUIImage() -> UIImage? {
        let imageName = "SmallImage"
        guard let uiimage = UIImage(named: imageName, in: Bundle.main, compatibleWith: nil) else {
            XCTFail("Could not load image named \(imageName)")
            return nil
        }
        let size = uiimage.size * uiimage.scale
        print("Testing image of size: \(size)")
        
        return uiimage
    }
    
    func testPerformanceRGBA8_CreateFromUIImage() {
        guard let uiimage = self.smallUIImage() else {
            XCTFail("Could not load uiimage")
            return
        }
        guard var dtsImage = DTSImageRGBA8(image: uiimage) else {
            XCTFail("Could not convert image to RGBA8")
            return
        }
        self.measure {
            dtsImage = DTSImageRGBA8(image: uiimage)!
        }
        
        let _ = dtsImage.width
    }
    func testPerformanceRGBA8_ConvertToUIImage() {
        guard let uiimage = self.smallUIImage() else {
            XCTFail("Could not load uiimage")
            return
        }
        guard let dtsImage = DTSImageRGBA8(image: uiimage) else {
            XCTFail("Could not convert image to RGBA8")
            return
        }
        
        guard let _ = dtsImage.toUIImage() else {
            XCTFail("Could not convert DTSImageRGBA8 back to UIImage")
            return
        }
        self.measure {
            _ = dtsImage.toUIImage()
        }
        
        let _ = dtsImage.width
        
    }
    
    func testPerformanceRGBAF_CreateFromUIImage() {
        guard let uiimage = self.smallUIImage() else {
            XCTFail("Could not load uiimage")
            return
        }
        guard var dtsImage = DTSImageRGBAF(image: uiimage) else {
            XCTFail("Could not convert image to RGBA8")
            return
        }
        self.measure {
            dtsImage = DTSImageRGBAF(image: uiimage)!
        }
        
        let _ = dtsImage.width
    }
    func testPerformanceRGBAF_ConvertToUIImage() {
        guard let uiimage = self.smallUIImage() else {
            XCTFail("Could not load uiimage")
            return
        }
        guard let dtsImage = DTSImageRGBAF(image: uiimage) else {
            XCTFail("Could not convert image to RGBA8")
            return
        }
        
        guard let _ = dtsImage.toUIImage() else {
            XCTFail("Could not convert DTSImageRGBA8 back to UIImage")
            return
        }
        self.measure {
            _ = dtsImage.toUIImage()
        }
        
        let _ = dtsImage.width
        
    }

}

func *(s: CGSize, f: CGFloat) -> CGSize {
    let newSize = CGSize(width: s.width * f,
                         height: s.height * f)
    return newSize
}
