//
//  YYPopulation.swift
//  Picassevo
//
//  Created by Yue Jia on 22/03/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class YYPopulation {
    var individuals : [YYIndividual] = [YYIndividual] ()
    
    init(individuals : [YYIndividual])
    {
        self.individuals = individuals
    }
    
    func evaluateFitness()
    {
        
        if(GlobalSearchSettings.EvaluationInParallel)
        {
            let dispatch_group = dispatch_group_create()
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            
            for i in 0..<self.individuals.count
            {
                let ind : YYIndividual = self.individuals[i]
                dispatch_group_async(dispatch_group, queue)
                {
                        ind.evaluateFitness()
                }
            }
            dispatch_group_wait(dispatch_group, DISPATCH_TIME_FOREVER)
        }
        else
        {
            for i in 0 ..< self.individuals.count
            {
                let ind : YYIndividual = self.individuals[i]
                ind.evaluateFitness()
            }
        }
    }
    
    var minimumFitness : Double
        {
            var minFit : Double = DBL_MAX;
            for i in 0 ..< self.individuals.count
            {
                let ind : YYIndividual = self.individuals[i]
                
                if ind.fitness < minFit {
                    minFit = ind.fitness
                }
            }
            return minFit
    }
    
    var maximumFitness : Double
        {
            var maxFit : Double = DBL_MIN;
            for i in 0 ..< self.individuals.count
            {
                let ind : YYIndividual = self.individuals[i]
                
                if ind.fitness > maxFit {
                    maxFit = ind.fitness;
                }
            }
            return maxFit;
    }
    
    
    var bestIndividual : YYIndividual!
        {
            var bestFitness : Double = 0.0
            
            if GlobalSearchSettings.Minimisation
            {
                bestFitness = self.minimumFitness
            }
            else
            {
                bestFitness = self.maximumFitness
            }
            for i in 0 ..< self.individuals.count
            {
                let ind : YYIndividual = self.individuals[i]
                if ind.fitness == bestFitness
                {
                    return ind
                }
            }
            return nil;
    }
    
    var bestFitness : Double
        {
            if self.bestIndividual != nil
            {
                return self.bestIndividual.fitness
            }
            else
            {
                return 0.0
            }
    }
    
    
}