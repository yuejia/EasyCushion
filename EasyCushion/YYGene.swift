//
//  YYGene.swift
//  Picassevo
//
//  Created by Yue Jia on 22/03/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class YYGene
{
    func copy() -> YYGene
    {
        return YYGene()
    }
    
    func mutate()
    {
        YYLogger.debug("Mutate a Gene, need to override this method!")
    }
}