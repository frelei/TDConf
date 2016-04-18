//
//  Helper.swift
//  TDConf
//
//  Created by Rodrigo Leite on 17/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import Foundation


/**
   Replacement function for Log that will output the filename, linenumber and function name.
 
 - parameter:: object: The object to log
 - parameter:: filename: The name of the file from where this function is called
 - parameter:: line: The line number in the file from where this function is called
 - parameter:: funcname: The function name from where this function is called
 */
public func Logging<T>(object: T, filename: String = #file, line: Int = #line, funcname: String = #function) {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss:SSS"
    let process = NSProcessInfo.processInfo()
    let threadId = "."
    print("\(dateFormatter.stringFromDate(NSDate())) \(process.processName))[\(process.processIdentifier):\(threadId)] \((filename as NSString).lastPathComponent)(\(line)) \(funcname):\r\t\(object)\n")
}