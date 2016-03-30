//
//  YYMutationOperator.swift
//  Picassevo
//
//  Created by Yue Jia on 22/03/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class YYMutationOperator
{
    
    class func uniformMutateIndividual(individual: YYIndividual)
    {
        for i in 0 ..< individual.chromosome.count        {
            let localUniformMutation = Double.random(0.0, upper: 1.0)
            
            if localUniformMutation < GlobalSearchSettings.UniformMutationRate {
                let gene: YYGene = individual.chromosome[i]
                gene.mutate()
            }
        }
    }
    
    class func uniformMutateIndividualAtLeastOnce(individual: YYIndividual)
    {
        var uniformMutationNumber = 0
        for i in 0 ..< individual.chromosome.count
        {
            let localUniformMutation = Double.random(0.0, upper: 1.0)
            
            if localUniformMutation < GlobalSearchSettings.UniformMutationRate {
                let gene: YYGene = individual.chromosome[i]
                gene.mutate()
                uniformMutationNumber += 1
            }
        }
        
        if uniformMutationNumber == 0 {
            let gene: YYGene = individual.chromosome[Int.random(0, upper: individual.chromosome.count)]
            gene.mutate()
        }
    }
    
    
    class func swapGeneForIndividual(individual: YYIndividual)
    {
        let aIndex = Int.random(0, upper: individual.chromosome.count)
        let bIndex = Int.random(0, upper: individual.chromosome.count)
        
        let aGene : YYGene = individual.chromosome[aIndex]
        let bGene : YYGene = individual.chromosome[bIndex]
        
        individual.chromosome[aIndex] = bGene
        individual.chromosome[bIndex] = aGene
    }
    
    
    class func mutationCrossoverIndividual(individual: YYIndividual)
    {
        let aIndex = Int.random(0, upper: individual.chromosome.count)
      //  var bIndex = Int.random(lower: 0, upper: individual.chromosome.count)
        
        var tmp = [YYGene]()
        
        for  i in aIndex..<individual.chromosome.count
        {
            tmp.append(individual.chromosome[i])
        }
        
        let stmp = tmp.shuffled()
        
        var j = 0
        for  i in aIndex..<individual.chromosome.count
        {
            individual.chromosome[i] = stmp[j]
            j += 1
        }
        
    }
    
    
    /*
    +(void) newGeneForIndividual: (YYEAIndividual *) individual;
    +(void) mutateIndividual: (YYEAIndividual *) individual;
    +(void) replaceGeneForIndividual: (YYEAIndividual *) individual;
    +(void) removeGeneForIndividual: (YYEAIndividual *) individual;
    +(void) uniformMutateIndividual:(YYEAIndividual *) individual;
    +(void) uniformMutateIndividualAtLeastOnce:(YYEAIndividual *) individual;
    
    +(YYEAPopulation *) mutateIndividual: (YYEAIndividual *) individual NTimes: (NSUInteger) N;
    */
}