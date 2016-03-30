//
//  YYSearchSettings.swift
//  Picassevo
//
//  Created by Yue Jia on 22/03/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class YYSearchSettings {
    var EvaluationInParallel: Bool = true
    var Minimisation: Bool = true
    var UniformMutationRate = 0.2
    var MaxNonImprovingGeneration = 5000
    var MaxNumberOfGeneration = 200
    var IndividualChromosomeSize = 80
    var PopulationSize = 240  // mod 4 = 0
    var NumberOfObjectives = 3
    var VerboseGenerationFilter = 100
}