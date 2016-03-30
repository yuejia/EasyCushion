//
//  YYFile.swift
//  YYMiniGP2015
//
//  Created by Yue Jia on 27/04/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class YYFile {
    
    static func makeDirectoryIfNotExist(path : String,  removeOld : Bool)
    {
        
        let fileManager = NSFileManager.defaultManager()
        
        if removeOld
        {
            do {
                try fileManager.removeItemAtPath(path)
            } catch _ {
            }
        }
        
        if !fileManager.fileExistsAtPath(path)
        {
            do {
                try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
            } catch _ {
            }
        }
        else
        {
            print("Cannot create new folder! try removeOld = true")
        }
    }
    
    static func saveStringToFile(str: String, path: String, name:String)
    {
        let newPath = "\(path)/\(name)"
        do {
            try str.writeToFile(newPath, atomically: false, encoding: NSUTF8StringEncoding)
        } catch _ {
        }
    }
    
    static func loadTextFile(path:String) -> String
    {
        return try! String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
    }
    
    static func loadTextFileToArray(path:String) -> [String]
    {
        let text = YYFile.loadTextFile(path)
        let lines = text.characters.split(isSeparator: { $0 == "\n" } ).map { String($0) }
        var res = [String]()
        for line in lines
        {
            res.append(line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        }
        return res
    }
    
    // load a simple setting file in "key:value" format
    static func loadTextFileToDictionary(path:String, splitBy str: Character) -> [String:String]
    {
        let text : String = YYFile.loadTextFile(path)
        var res = [String:String]()
        //let lines = split(text, maxSplit: Int.max,isSeparator: { $0 == "\n" } )
        let lines = text.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        for line in lines
        {
            if line.characters.count != 0
            {
                var varInfo = line.characters.split(isSeparator: { $0 == str } ).map { String($0) }
                let varName = varInfo[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let varValue = varInfo[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                res[varName] = varValue
            }
        }
        return res
    }

    // load a simple setting file in "key:value" format
    static func loadTextFileToArray(path:String, splitBy str: Character) -> [[String]]
    {
        let text : String = YYFile.loadTextFile(path)
        var res = [[String]]()
        //let lines = split(text, maxSplit: Int.max,isSeparator: { $0 == "\n" } )
        let lines = text.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        for line in lines
        {
            if line.characters.count != 0
            {
                var currArray = [String]()
                var varInfo = line.characters.split(isSeparator: { $0 == str } ).map { String($0) }
                let varName = varInfo[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let varValue = varInfo[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                currArray.append(varName)
                currArray.append(varValue)
                res.append(currArray)
            }
        }
        return res
    }
    
    
    static func makeTimeStampDirectory(path: String) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-SSSS"
        let dstr = formatter.stringFromDate(NSDate())
        let newPath = "\(path)/\(dstr)"
        YYFile.makeDirectoryIfNotExist(newPath,removeOld: false)
        return newPath
    }
    
    // load a simple setting file in "key:value" format
    static func loadSettingFile(path:String) -> [String:String]
    {
        return YYFile.loadTextFileToDictionary(path, splitBy : ":")
        
        
    }
    
}