//
//  YYLogger.swift
//  YYLogger
//
//  Created by Yue Jia on 07/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

private var AllLog: String = ""
private var YYLoggerDebugLog: String = ""
private var YYLoggerInfoLog: String = ""
private var YYLoggerErrorLog: String = ""


//private var infoLog : String = ""
private var YYLoggerDisplayLog : Bool = true

private var YYLoggerDebug : Bool = false
private var YYLoggerInfo : Bool = true
private var YYLoggerError : Bool = true


class YYLogger {
    
    class func switchOnDisplay()
    {
        YYLoggerDisplayLog = true
    }
    
    class func switchOffDisplay()
    {
        YYLoggerDisplayLog = false
    }
    
    class func switchOnDebug()
    {
        YYLoggerDebug = true
    }
    
    class func switchOffDebug()
    {
        YYLoggerDebug = false
    }
    
    class func switchOnError()
    {
        YYLoggerError = true
    }
    
    class func switchOffError()
    {
        YYLoggerError = false
    }
    
    class func showAllDebug()
    {
        print(YYLoggerDebugLog)
    }
    
    class func debug<T>(object: T)
    {
        if YYLoggerDebug
        {
            let debugMsg =  "\(YYLogger.timeStamp()) Debug: \(object)\n"
            YYLoggerDebugLog += debugMsg
            if YYLoggerDisplayLog
            {
                print(debugMsg, terminator: "")
                fflush(__stdoutp)
            }
        }
    }
    
    class func info<T>(object: T)
    {
        if YYLoggerInfo
        {
            let infoMsg =  "\(YYLogger.timeStamp()) Info: \(object)\n"
            YYLoggerInfoLog += infoMsg
            if YYLoggerDisplayLog
            {
                print(infoMsg, terminator: "")
                fflush(__stdoutp)
            }
        }
    }
    
    class func error<T>(object: T)
    {
        if YYLoggerError
        {
            let errorMsg =  "\(YYLogger.timeStamp()) Error: \(object)\n"
            YYLoggerErrorLog += errorMsg
            if YYLoggerDisplayLog
            {
                print(errorMsg, terminator: "")
                fflush(__stdoutp)
            }
        }
    }
    
    
    
    class func timeStamp() -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.stringFromDate(NSDate())
    }
    
}