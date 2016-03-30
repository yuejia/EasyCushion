//
//  DiscussionOrder.swift
//  EasyCushion
//
//  Created by Yue Jia on 10/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class DiscussionOrder : YYIndividual {
    
    var leaderGaps = 4.0
    override init()
    {
        super.init()
    }
    
    init(papers: [Int: Paper], discussionPaper: [Int])
    {
        super.init()
        
        let newKeys = discussionPaper.shuffled()
        
        for i in 0..<discussionPaper.count
        {
            if let paper = papers[newKeys[i]]
            {
                self.chromosome.append(paper)
            }
            else
            {
                YYLogger.error("empty index \(i)"  )
            }
        }
    }
    
    func copy() -> DiscussionOrder
    {
        
        let newInd = DiscussionOrder()

        for i in 0..<GlobalSearchSettings.IndividualChromosomeSize
        {
            let p = self.chromosome[i] as! Paper
           // newInd.chromosome.append(p.copy())
            newInd.chromosome.append(p)
        }
        
        
       
        newInd.fitness = self.fitness
        
        for i in 0 ..< 5   //TODO fixme self.obj.count
        {
            newInd.obj[i] = self.obj[i]
        }
        newInd.rank = self.rank
        newInd.fitness1 = self.fitness1
        newInd.fitness2 = self.fitness2
        newInd.fitness3 = self.fitness3
        newInd.crowdDist = self.crowdDist
        newInd.constr_violation  = self.constr_violation
      
        return newInd
    }
    
    
    func getReviewerExitArray() -> [Int]
    {
         var exit = [Int]()
        var room = [Int]() // this is a new room outside of the PC Meeting
        

        for i in 0  ..< self.chromosome.count
        {
            let paper  =  self.chromosome[i]as! Paper
            var exitTimes = 0
            //call all the non conflict pc back to room
            for var r:Int = 0 ; r < room.count ; r=r+1
            {
                let rr = room[r]
                if !paper.conflicts.contains(rr)
                {
                    room.removeAtIndex(r)
                    r = r - 1
                }
                else
                {
                    // Do nothing if there is a conflict
                }
                
            }
            
            // check if the reviewer of paper in the room
            for r in paper.conflicts
            {
                if !room.contains(r)
                {
                    // if true
                    // fitness + 1
                    // reviewer go out
                    room.append(r)
                    exitTimes+=1
                }
                else
                {
                    // the pc is in the room, so do nothing
                }
            }
            
            // else
            // do nothing
            
            exit.append(exitTimes)
        }
        return exit
    }
    
    func getReviewerGapArray() -> [Int]
    {
        var gaps = [Int]()
        
        for i in 0  ..< self.chromosome.count
        {
            let paper  =  self.chromosome[i]as! Paper
            
            var total_gap = 100000000
            for reviewer in paper.reviewers
            {
                if reviewer == paper.leader
                {
                    continue
                }
                var sameLeaderGap = 0
                if i+1 < self.chromosome.count
                {
                    for j in (i + 1)  ..< self.chromosome.count
                    {
                        let nextPaper  =  self.chromosome[j]as! Paper
                        
                        if nextPaper.reviewers.contains(reviewer)
                        {
                            break
                        }
                        else
                        {
                            if j != self.chromosome.count - 1
                            {
                                sameLeaderGap += 1
                            }
                            else
                            {
                                sameLeaderGap += 819
                            }
                        }
                    }
                }
                else
                {
                    sameLeaderGap += 819
                }
                
                if  sameLeaderGap <= total_gap
                {
                    total_gap = sameLeaderGap
                }
            }
            gaps.append(total_gap)
        }
        return gaps
    }
    
    func getLeaderGapArray() -> [Int]
    {
        var gaps = [Int]()
        
        for i in 0  ..< self.chromosome.count
        {
            let paper  =  self.chromosome[i]as! Paper
            
            let leader = paper.leader
            var sameLeaderGap = 0
            
            if i+1 < self.chromosome.count
            {
                for j in (i + 1)  ..< self.chromosome.count
                {
                    let nextPaper  =  self.chromosome[j]as! Paper
                    
                    
                    let currLeader =  nextPaper.leader
                    if currLeader == leader
                    {
                        break
                    }
                    else
                    {
                        if j != self.chromosome.count - 1
                        {
                            sameLeaderGap += 1
                        }
                        else
                        {
                            sameLeaderGap += 819
                        }
                    }
                }
            }
            else
            {
                sameLeaderGap += 819
            }
            
            gaps.append(sameLeaderGap)
        }
        return gaps
    }
    
    func checkConnectedPaper() -> (positive: Int,negtive : Int)
    {
        var positive = 0
        var negtive = 0
        
        for var i = 0 ; i < self.chromosome.count ; i += 1
        {
            let paper  =  self.chromosome[i]as! Paper
            var j = 0
            if paper.outcome == -1 || paper.outcome == 1
            {
                var sameTypeCount = 0
                
                if i+1 <  self.chromosome.count
                {
                    for j = i + 1 ; j < self.chromosome.count ; j += 1
                    {
                        let nextPaper  =  self.chromosome[j]as! Paper
                        
                        if paper.outcome == nextPaper.outcome
                        {
                            sameTypeCount += 1
                        }
                        else
                        {
                            break
                        }
                    }
                    
                    i = j - 1
                    
                    if paper.outcome == 1
                    {
                        positive += sameTypeCount
                    }
                    else
                    {
                        negtive += sameTypeCount
                    }
                    
                }
            }
        }
        
        return (positive, negtive)
    }
    
   //original slow but correct
    override func evaluateFitness()
    {
        var room = [Int]() // this is a new room outside of the PC Meeting
        
        self.fitness1 = 0.0
        self.fitness2 = 0.0
        self.fitness3 = 0.0
       
        for i in 0  ..< self.chromosome.count
        {
            let paper  =  self.chromosome[i]as! Paper
            
            
            
            for  reviewer in paper.reviewers
            {
                var sameLeaderGap = 0.0
                if i+1 < self.chromosome.count
                {
                    for j in (i + 1)  ..< self.chromosome.count
                    {
                        let nextPaper  =  self.chromosome[j]as! Paper
                        
                        
                        // let currLeader =  nextPaper.leader
                        if nextPaper.reviewers.contains(reviewer)
                        {
                            break
                        }
                        else
                        {
                            if j != self.chromosome.count - 1
                            {
                                sameLeaderGap += 1.0
                            }
                            else
                            {
                                sameLeaderGap += 819.0
                            }
                        }
                    }
                    
                    if self.leaderGaps >= sameLeaderGap
                    {
                        if reviewer != paper.leader
                        {
                            self.fitness3 += (self.leaderGaps - sameLeaderGap) * (self.leaderGaps - sameLeaderGap)
                        }
                        else
                        {
                            self.fitness3 += 3 * (self.leaderGaps - sameLeaderGap) * (self.leaderGaps - sameLeaderGap)
                        }
                    }
                    
                }
                
            }
            
        }

        
        /* leader gaps
        for var i = 0 ; i < self.chromosome.count ; i++
        {
        let paper  =  self.chromosome[i]as! Paper
        
        let leader = paper.leader
        var sameLeaderGap = 0.0
        
        
        if i+1 < self.chromosome.count
        {
        for var j = i + 1 ; j < self.chromosome.count ; j++
        {
        let nextPaper  =  self.chromosome[j]as! Paper
        
        
        let currLeader =  nextPaper.leader
        if currLeader == leader
        {
        break
        }
        else
        {
        if j != self.chromosome.count - 1
        {
        sameLeaderGap += 1.0
        }
        else
        {
        sameLeaderGap += 819.0
        }
        }
        }
        
        if self.leaderGaps >= sameLeaderGap
        {
        self.fitness3 += (self.leaderGaps - sameLeaderGap) * (self.leaderGaps - sameLeaderGap)
        }
        }
        }
        */

        
        for var i = 0 ; i < self.chromosome.count ; i += 1
        {
            let paper  =  self.chromosome[i]as! Paper
            var j = 0
            if paper.outcome == -1 || paper.outcome == 1
            {
                var sameTypeCount = 0
                
                if i+1 <  self.chromosome.count
                {
                    for j = i + 1 ; j < self.chromosome.count ; j += 1
                    {
                        let nextPaper  =  self.chromosome[j]as! Paper
                        
                        if paper.outcome == nextPaper.outcome
                        {
                            sameTypeCount += 1
                        }
                        else
                        {
                            break
                        }
                    }
                    
                    i = j - 1
                    
                    self.fitness2 += Double(sameTypeCount * sameTypeCount)
                    // self.fitness2 += Double(sameTypeCount)
                }
            }
        }
        
        
        for i in 0  ..< self.chromosome.count
        {
            let paper  =  self.chromosome[i]as! Paper
//            print("Paper id : \(paper.easyChairID) -------------------------------------")
            //call all the non conflict pc back to room
            for var r:Int = 0 ; r < room.count ; r=r+1
            {
                let rr = room[r]
                if !paper.conflicts.contains(rr)
                {
                    //come back room
//                    print("Come back : \(GlobalECManager?.reviewers[rr]!.name)")
                    room.removeAtIndex(r)
                    r = r - 1
                }
                else
                {
                    // Do nothing if there is a conflict
                }
                
            }
            
            // check if the reviewer of paper in the room
            for r in paper.conflicts
            {
                if !room.contains(r)
                {
                    // if true
                    // fitness + 1
                    // reviewer go out
                    //println(r)
                    room.append(r)
//                    print("Go out  : \(GlobalECManager?.reviewers[r]!.name)")
                    fitness1+=1
                }
                else
                {
                    // the pc is in the room, so do nothing
                }
            }
            
            // else
            // do nothing
            
            
        }
        
        self.obj[0] = fitness2
        self.obj[1] = fitness3
        self.obj[2] = fitness1
        self.fitness =  ( fitness1 + fitness2 + fitness3 )  /// 3.0
    }
    
}