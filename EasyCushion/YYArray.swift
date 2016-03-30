//
//  YYArray.swift
//  YYTools
//
//  Created by Yue Jia on 10/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation


extension Array {

    func shuffled() -> [Element] {
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            guard i != j else { continue }
            swap(&list[i], &list[j])
        }
        return list
    }

}