//
//  RandomBlocksArray.swift
//  Blocks-slide
//
//  Created by Serx on 3/23/16.
//  Copyright © 2016 serxlee. All rights reserved.
//

import Foundation
import UIKit

class RandomBlocksArray{
    
    var randomArray =
        [0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0]
    
    func startRandom(number: Int) -> [Int]{
        
        let aa = createRandomMan(0, end: 35)
        
        for _ in 1...number{
            randomArray[aa()] = 1
        }
        return randomArray
    }
    
    
    func randomAllBlocks(numberBlocks: Int) -> () -> Int!{
        
        let aa = createRandomMan(0, end: numberBlocks - 1)
        
        func start() -> Int!{
            return aa()
        }
        return start
    }
    
    
    func createRandomMan(start: Int, end: Int) ->() ->Int! {

        var nums = [Int]();
        for i in start...end{
            nums.append(i)
        }
        
        func randomMan() -> Int! {
            if !nums.isEmpty {

                let index = Int(arc4random_uniform(UInt32(nums.count)))
                return nums.removeAtIndex(index)
            }else {

                return nil
            }
        }
        
        return randomMan
    }
}