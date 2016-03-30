//
//  YYIndividual.swift
//  Picassevo
//
//  Created by Yue Jia on 22/03/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class YYIndividual
{
    var chromosome : [YYGene] = [YYGene]()
    var fitness : Double = 0.0
    var obj : [Double] = [Double]()
    var rank : Int = 0
    var fitness1 : Double = 0.0
    var fitness2 : Double = 0.0
    var fitness3 : Double = 0.0
    var crowdDist : Double = 0.0
    var constr_violation : Double = 0.0
    func  evaluateFitness()
    {
        YYLogger.debug("fitness function: need to override this method")
    }
    
    init()
    {
        for _ in 0..<5 // TODO: fixme GlobalSearchSettings.NumberOfObjectives
        {
            self.obj.append(0.0)
        }
    }
}