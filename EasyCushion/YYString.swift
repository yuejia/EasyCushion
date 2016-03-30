//
//  YYString.swift
//  YYTools
//
//  Created by Yue Jia on 09/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class YYString {
    
    // search and replace string
    class func stringReplace(string string: String, oldValue:String, newValue:String) -> String
    {
        return string.stringByReplacingOccurrencesOfString(oldValue, withString: newValue, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    // return true if yes otherwise false
    class func stringToBool(string string: String) ->Bool
    {
        return string == "yes"
    }
    
    //remove comma in quotation e.g. "A, B" -> "A  B"
    class func removeCommaInQuotation (string string: String) -> String
    {
        return YYString.removeCharacterInQuotation(string: string, character: YYCharacter.getIntValue(","))
    }
    
    //remove comma in quotation e.g. "A\r\n B" -> "A  B"
    class func removeNewLineInQuotation (string string: String) -> String
    {
        return YYString.removeCharacterInQuotation(string: string, character: 10)
       
    }
    
    //remove comma in quotation e.g. "A\r\n B" -> "A  B"
    class func removeNewLineAndReturnInQuotation (string string: String) -> String
    {
        //let newString = YYString.removeCharacterInQuotation(string, character: 10)
        //return YYString.removeCharacterInQuotation(newString, character: 13)
        
        return YYString.removeCharacterInQuotation(string: string, character1: 10, character2: 13)
    }
    
    //remove character in quotation e.g. "Ac B" -> "A  B"
    class func removeCharacterInQuotation (string string: String, character: Int) -> String
    {
        var inQuotation = false
        var newString = ""
        
        let guiFlat = string.characters.count > 100000
        
        // IF GUI
        if guiFlat
        {
            YYProgressController.sharedController().maxProgress = Double(string.characters.count)
            YYProgressController.sharedController().status = "Cleaning Text ..."
        }
        for c in string.characters
        {
            // IF GUI
            if guiFlat
            {
                YYProgressController.sharedController().increaseProgressByOne()
            }
            if c == "\"" && !inQuotation
            {
                inQuotation = true
            }
            else if c == "\"" && inQuotation
            {
                inQuotation = false
            }
            
            if YYCharacter.getIntValue(c) == character && inQuotation
            {
                newString += " "
            }
            else
            {
                newString += String(c)
            }
        }
        
        return newString
    }
    
    
    //remove character in quotation e.g. "Ac B" -> "A  B"
    class func removeCharacterInQuotation (string string: String, character1: Int, character2: Int) -> String
    {
        var inQuotation = false
        var newString = ""
        
        let guiFlat = string.characters.count > 100000
        
        // IF GUI
        if guiFlat
        {
            YYProgressController.sharedController().maxProgress = Double(string.characters.count)
            YYProgressController.sharedController().status = "Cleaning Text ..."
        }
        for c in string.characters
        {
            // IF GUI
            if guiFlat
            {
                YYProgressController.sharedController().increaseProgressByOne()
            }
            if c == "\"" && !inQuotation
            {
                inQuotation = true
            }
            else if c == "\"" && inQuotation
            {
                inQuotation = false
            }
            
            if YYCharacter.getIntValue(c) == character1 && inQuotation
            {
                newString += " "
            }
            else if YYCharacter.getIntValue(c) == character2 && inQuotation
            {
                newString += " "
            }
            else
            {
                newString += String(c)
            }
        }
        
        return newString
    }
    
    class func createStringPlaceholder(ori ori:String, placeholder:String) -> String
    {
        var newString = ""
        for _ in 0..<ori.characters.count
        {
            newString += placeholder
        }
        return newString
    }

}