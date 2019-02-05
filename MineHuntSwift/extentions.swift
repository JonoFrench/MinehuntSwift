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
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.finishEncoding()
        return NSKeyedUnarchiver(forReadingWith: data as Data)
    }
}
