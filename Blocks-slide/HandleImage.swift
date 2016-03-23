//
//  HandleImage.swift
//  Blocks-slide
//
//  Created by Serx on 3/22/16.
//  Copyright © 2016 serxlee. All rights reserved.
//

import Foundation
import UIKit

class HandleImage {
    
    var doubleArrayPoint = DoubleDimensionalArrayPoint(rows: 4, columns: 4)
    
    var rawImage = UIImage(named: "test")
    var getBlockLengh: CGFloat = 0.0
    var getAllLengh: CGFloat = 0.0
    
    var point4: [CGPoint] =
        [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 250.0, y: 0.0),
        CGPoint(x: 0.0, y: 250.0), CGPoint(x: 250.0, y: 250.0)]
    let point9: [CGPoint] =
        [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 166.666, y: 0.0), CGPoint(x: 333.333, y: 0.0),
        CGPoint(x: 0.0, y: 166.666), CGPoint(x: 166.666, y: 166.666), CGPoint(x: 333.333, y: 166.666),
        CGPoint(x: 0.00, y: 333.333), CGPoint(x: 166.666, y: 333.333), CGPoint(x: 333.333, y: 333.333)]
    let point16: [CGPoint] =
        [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 125.0, y: 0.0), CGPoint(x: 250.0, y: 0.0),CGPoint(x: 375.0, y: 0.0),
        CGPoint(x: 0.0, y: 125.0), CGPoint(x: 125.0, y: 125.0), CGPoint(x: 250.0, y: 125.0), CGPoint(x: 375.0, y: 125.0),
        CGPoint(x: 0.0, y: 250.0), CGPoint(x: 125.0, y: 250.0), CGPoint(x: 250.0, y: 250.0),  CGPoint(x: 375.0, y: 250.0),
        CGPoint(x: 0.0, y: 375.0), CGPoint(x: 125.0, y: 375.0),  CGPoint(x: 250.0, y: 375.0), CGPoint(x: 375.0, y: 375.0)]
         
    var number: (Int, Int) = (0, 0)
    
    
    func smallImage() -> UIImage{
        
        if number.0 == 4{
            return (rawImage?.crop(CGRect(origin: point4[number.1], size: CGSize(width: 250.0, height: 250.0))))!
        }else if number.0 == 9{
            return (rawImage?.crop(CGRect(origin: point9[number.1], size: CGSize(width: 166.666, height: 166.666))))!
        }else if number.0 == 16{
            return (rawImage?.crop(CGRect(origin: point16[number.1], size: CGSize(width: 125.0, height: 125.0))))!
        }
        
        return rawImage!
    }
}