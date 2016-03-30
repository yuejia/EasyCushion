//
//  SBSE.swift
//  EasyCushion
//
//  Created by Yue Jia on 10/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//
//  Implement NSGAII based on Deb's version 1.6

import Foundation

class SBSE : YYSearch{
    
    var reviewers: [Int:Reviewer]
    var papers: [Int:Paper]
    var discussionPaper: [Int]
    init(reviewers: [Int:Reviewer], papers: [Int:Paper], discussionPaper: [Int])
    {
        self.reviewers = reviewers
        self.papers = papers
        self.discussionPaper = discussionPaper
        GlobalSearchSettings.IndividualChromosomeSize = discussionPaper.count
        super.init()
        
        YYLogger.debug("Create PicassevoSearch")
    }

    func initPopulation() -> YYPopulation
    {
        var inds = [YYIndividual]()
        
        for _ in 0..<GlobalSearchSettings.PopulationSize
        {
            let ind = DiscussionOrder(papers: self.papers, discussionPaper: self.discussionPaper)
            inds.append(ind)
        }
        
        return YYPopulation(individuals: inds)
    }
    
    //  Implement NSGAII based on Deb's version 1.6
    override func startEvolution()
    {
       
        if self.state == YYSearchState.running
        {
            YYLogger.debug("PicaasevoSearch: is running")
            return
        }
        else
        {
             YYLogger.debug("PicaasevoSearch:startEvolution()")
            self.state = YYSearchState.running
        }
        dispatch_async(dispatch_get_main_queue(), {
            GlobalParetoSence?.cleanRootNote()
        
        })
        
        self.resetRuntimeSettings()
    
        self.bestIndividual = DiscussionOrder(papers: self.papers, discussionPaper: self.discussionPaper)
        
        
        var parentPop = self.initPopulation()
        print("\n Initialization done, now performing first generation");
        
        parentPop.evaluateFitness()
        
        self.currNumberOfGeneration = 1
    
        var childPop : YYPopulation
        
        GlobalProgressController.maxProgress = Double(GlobalSearchSettings.MaxNumberOfGeneration)
        
        while self.currNumberOfGeneration < GlobalSearchSettings.MaxNumberOfGeneration
        {
            dispatch_async(dispatch_get_main_queue(), {
                
                GlobalProgressController.status = "Searching Discussion Order: Gen \(self.currNumberOfGeneration)"
                GlobalProgressController.increaseProgressByOne()
            })
                
            childPop =  self.searchOperator.selectionAndCrossover(old_pop: parentPop)
            self.searchOperator.mutationPopulation(pop: childPop)
            childPop.evaluateFitness()
            let mixPop = self.searchOperator.merge(pop1: parentPop, pop2: childPop)
            parentPop = self.searchOperator.fillNondominatedSort(mixed_pop: mixPop)
            
           
            //self.bestIndividual.evaluateFitness()
            //self.bestFitness = self.bestIndividual.fitness
            
            // update GUI
            if Int(self.currNumberOfGeneration) % 4 == 0
            {
                 print("\(self.currNumberOfGeneration) : \(parentPop.individuals[0].obj[0])  \(parentPop.individuals[0].obj[1])  \(parentPop.individuals[0].obj[2])")
                GlobalParetoSence?.addYYPopulation(pop: parentPop)
        
                dispatch_async(dispatch_get_main_queue(), {
                    GlobalScnView?.needsDisplay = true
                })
            }
            
          
            
            self.currNumberOfGeneration = self.currNumberOfGeneration + 1
        }
        self.runningTimeInSecond = fabs(self.startTime.timeIntervalSinceNow)
        print(self.generateReport())
        self.state = YYSearchState.idle
        
   
           // println("Final \(self.currNumberOfGeneration) : \(parentPop.individuals[0].obj[0])  \(parentPop.individuals[0].obj[1])  \(parentPop.individuals[0].obj[2])")
        print("Done")
            GlobalParetoSence?.addYYPopulation(pop: parentPop)
            
            dispatch_async(dispatch_get_main_queue(), {
                GlobalScnView?.needsDisplay = true
            })
     
    }
    
}