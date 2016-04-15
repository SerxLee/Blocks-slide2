//
//  propertiesOfViewController.swift
//  Blocks-slide
//
//  Created by Serx on 16/4/6.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class allProperties: NSObject{
    
    
    var stateArray: [Int] =
    [0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,-1]
    
    
    var BlocksPositionXY: [CGPoint] = []
    
    var doubleArrayNumberBlcoks = DoubleDimensionalArrayInt(rows: 10, columns: 10)
    var doubleArrayBoolBlocks = DoubleDimensionalArrayBool(rows: 10, columns: 10)
    
    var doubleArrayBoolImage = DoubleDimensionalArrayInt(rows: 10, columns: 10)
    
    var doubleArrayPointBlocks = DoubleDimensionalArrayPoint(rows: 10, columns: 10)
    var doubleArrayChooseBlocks = DoubleDimensionalArrayBool(rows: 10, columns: 10)
    
    //the second view size
    var grayView: UIView!
    var grayViewLenght: CGFloat!
    var grayViewHeight: CGFloat!
    
    //set the oringinal position and the lenght of the blocks (face to the grayview)
    var positionOfBlcoks = CGPoint(x: 0.0, y: 0.0)
    var sizeOfBlocks: CGSize!
    var blockLenght: CGFloat!
    
    
    //swipe every direction
    var swipeUp = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    var swipeLeft = UISwipeGestureRecognizer()
    
    //tap gesture
    var tapSingleFingerOneClick = UITapGestureRecognizer()
    var tapSingleFingerDoubleClick = UITapGestureRecognizer()
    
    //the move Event use
    var FSTBlocks: [(Int, Int)] = [(-1, -1),(-1, -1),(-1, -1)]
    var Nums: [(Int, Int)] = [(-1, -1),(-1, -1),(-1, -1)]
    //for fore direction x and y
    let numAdd: [(Int, Int)] = [(0, 0),(0, -1), (0, 1), (-1, 0), (1, 0)]
    var firstTimeToMove = true
    
    //MARK: coreData
    var managedContext: NSManagedObjectContext!
    var markEntity: NSEntityDescription!
    var markFetch: NSFetchRequest!
    
    
    //the data get from the coreData, the first of the result dictionatry.
    var resultOfMark: NSDictionary!
    
    //mark time
    
}