//
//  YYSearch.swift
//  Picassevo
//
//  Created by Yue Jia on 22/03/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

var GlobalSearchSettings : YYSearchSettings = YYSearchSettings()

enum YYSearchState {
    case idle
    case running
    case pause
}

class YYSearch {
    
    // MARK: - Data
    // MARK: Settings
    //var settings : YYSearchSettings = YYSearchSettings()
    
    // MARK: Result
    var bestFitness : Double = 0.0
    var bestIndividual : YYIndividual!
    
    // MARK: State
    var numOfNonImprovingGeneration : Int = 0
    var currNumberOfGeneration : Int = 0
    var state : YYSearchState = YYSearchState.idle
    
    // MARK: Timing
    var startTime : NSDate = NSDate()
    var runningTimeInSecond : Double = 0.0
    
    // MARK: Generation
    var currGeneration : YYPopulation!
    //var histGeneration
    
    var searchOperator : YYSearchOperator =  YYSearchOperator()
    
    init()
    {
        YYLogger.debug("Create YYSearch")
    }
    
    // MARK: - Functions
    func generateReport() -> String
    {
        return "Time: \(self.runningTimeInSecond)\nGenerations: \(self.currNumberOfGeneration)\nFitness: \(self.bestFitness)"
    }
    
    func startEvolution()
    {
        self.resetRuntimeSettings()
        YYLogger.debug("Start YYSearch")
        self.runningTimeInSecond = fabs(self.startTime.timeIntervalSinceNow)
    }
    
    func resetRuntimeSettings()
    {
        YYLogger.debug("YYSearch:resetRuntimeSettings()")
        
        self.state == YYSearchState.idle
        self.bestFitness = 0.0
        self.numOfNonImprovingGeneration = 0
        self.currNumberOfGeneration = 0
        self.startTime = NSDate()
        self.runningTimeInSecond = 0.0;
        self.bestIndividual = nil;
    }
    
    // MARK: Private functions
    
    
}
