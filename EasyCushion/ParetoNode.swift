//
//  ParetoNode.swift
//  EasyCushion
//
//  Created by Yue Jia on 12/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

import SceneKit

class ParetoNode : SCNNode {
    
    var individual : YYIndividual?
    
    init(geometry: SCNGeometry, ind:YYIndividual)
    {
        super.init()
        super.geometry = geometry
        self.individual = ind //(ind as DiscussionOrder).cop
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}