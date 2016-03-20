//
//  storeTheLastTime.swift
//  Blocks-slide
//
//  Created by Serx on 3/18/16.
//  Copyright © 2016 serxlee. All rights reserved.
//

import Foundation
import UIKit

class storeTheLastTime {
    
    //a array need to storage
    var toWriteArray: NSMutableArray!
    var toReadArray: NSArray!
    
    func startToWrite(){
        
        let home = NSHomeDirectory() as NSString
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let filePath = docPath.stringByAppendingPathComponent("notDoneGame.plist")
        
        toWriteArray.writeToFile(filePath, atomically: true)
        print(filePath)
    }
    
    func startToRead(){
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let filePath = docPath.stringByAppendingPathComponent("notDoneGame.plist")
        toReadArray = NSArray(contentsOfFile: filePath)
        
//                print(toReadArray)
    }
}
