//
//  segueIdentifier.swift
//  Blocks-slide
//
//  Created by Serx on 16/4/16.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import Foundation


protocol segueHandleIdentifier{
    associatedtype SegueIdentifier: RawRepresentable
}

extension segueHandleIdentifier where Self: MenuController, SegueIdentifier.RawValue == String{
    
    
}