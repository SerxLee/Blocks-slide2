//
//  UIImageHelper.swift
//  Blocks-slide
//
//  Created by Serx on 3/22/16.
//  Copyright © 2016 serxlee. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore
import CoreGraphics


enum UIImageContentMode {
    case ScaleToFill, ScaleAspectFit, ScaleAspectFill
}


extension UIImage{
    func crop(bounds: CGRect) -> UIImage? {
        return UIImage(CGImage: CGImageCreateWithImageInRect(self.CGImage, bounds)!,
            scale: 0.0, orientation: self.imageOrientation)
    }
    
    func resize(size:CGSize, contentMode: UIImageContentMode = .ScaleToFill) -> UIImage? {
        let horizontalRatio = size.width / self.size.width;
        let verticalRatio = size.height / self.size.height;
        var ratio: CGFloat!
        
        switch contentMode {
        case .ScaleToFill:
            ratio = 1
        case .ScaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .ScaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let context = CGBitmapContextCreate(nil, Int(rect.size.width), Int(rect.size.height), 8, 0, colorSpace, bitmapInfo.rawValue)
        
        let transform = CGAffineTransformIdentity
        
        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(context, transform);
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, CGInterpolationQuality(rawValue: 3)!)
        
        
        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))
        
        // Draw into the context; this scales the image
        CGContextDrawImage(context, rect, self.CGImage)
        
        // Get the resized image from the context and a UIImage
        let newImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }
}

