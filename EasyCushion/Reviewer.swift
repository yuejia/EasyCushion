//
//  Reviewer.swift
//  EasyCushion
//
//  Created by Yue Jia on 10/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class Reviewer
{
    var name: String = ""
    var easyChairID: Int = 0
    var conflictedReviewers: [Int:[Int]] = [Int:[Int]]()
    //var conflictedReviewers: [Int] = [Int]()
    
    init(reviewerId: Int, name:String)
    {
        self.easyChairID = reviewerId
        self.name = name
    }
    
    func conflictedReviewers(reviewerId: Int, paperId: Int)
    {
        if let ca = self.conflictedReviewers[reviewerId]
        {
            self.conflictedReviewers[reviewerId]!.append(paperId)
        }
        else
        {
            self.conflictedReviewers[reviewerId] = [paperId]
        }
    }
    
}