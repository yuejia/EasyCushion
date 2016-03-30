//
//  Paper.swift
//  EasyCushion
//
//  Created by Yue Jia on 09/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class Paper : YYGene {
    
    var easyChairID: Int = 0
    var title : String = ""
    var decision : String = ""
    var reviewers : [Int] = [Int] ()
    var conflicts : [Int] = [Int] ()
    var scores :[Int] = [Int]()
    var outcome : Int = -2
    var leader: Int = 0
    //var number : Int = 0
    //var content : String = ""
    //var authors : [Author] = [Author] ()
    //var leader = ""
    //var grades : [Int] = [Int]()
    //var conflicts = {}
    
    func computeOutcome()
    {
        var score: Int = 0
        for s in self.scores
        {
            score += s
        }
        
        if self.scores.count == 0
        {
            self.outcome = 0
        }
        
        if self.scores.count > 0
        {
            let avg = Double(score) / Double(self.scores.count)
            if avg == 0
            {
                self.outcome = 0
            }
            else if avg > 0
            {
                self.outcome = 1
            }
            else{
                self.outcome = -1
            }
        }
        else
        {
            self.outcome = -2
        }
    }
    
    
    init(paperId: Int,
        title: String,
        decision: String)
    {
        self.easyChairID = paperId
        self.title = title
        self.decision = decision
        super.init()
    }
    
    func addScore(score:Int)
    {
        self.scores.append(score)
    }
    
    func addReviewer(reviewerId: Int)
    {
        self.reviewers.append(reviewerId)
    }
    
    func addConflict(reviewerId: Int)
    {
        self.conflicts.append(reviewerId)
    }
    
    func addLeader(reviewerId: Int)
    {
        if !self.reviewers.contains(reviewerId) {
            YYLogger.error("Cannot fid reivewer \(reviewerId)")
        }
        else
        {
            self.leader = reviewerId
        }
    }
    
}