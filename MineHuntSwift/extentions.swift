//
//  extentions.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 30/05/2015.
//  Copyright (c) 2015 Jonathan French. All rights reserved.
//

import Foundation


extension NSCoder {
    class func empty() -> NSCoder {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.finishEncoding()
        return NSKeyedUnarchiver(forReadingWithData: data)
    }
}
