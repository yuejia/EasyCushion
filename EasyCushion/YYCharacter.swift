//
//  YYCharacter.swift
//  EasyCushion
//
//  Created by Yue Jia on 09/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation


class YYCharacter {
    class func debugCharacter(c:Character) -> String
    {
        let characterString = String(c)
        let scalars = characterString.unicodeScalars
        
        return "\(characterString): \(scalars[scalars.startIndex].value)\n"
    }
    
    
    class func getIntValue(c:Character) -> Int
    {
        let characterString = String(c)
        let scalars = characterString.unicodeScalars
        return Int(scalars[scalars.startIndex].value)
    }
}