//
//  ParetoScene.swift
//  EasyCushion
//
//  Created by Yue Jia on 11/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation
import SceneKit

class ParetoScence : SCNScene
{
    
    var selectedNode : SCNNode?
    var cameraNode : SCNNode?
    var xMin = CGFloat(1000.0)
    var xMax = CGFloat(0.0)
    var yMin = CGFloat(1000.0)
    var yMax = CGFloat(0.0)
    var zMin = CGFloat(1000.0)
    var zMax = CGFloat(0.0)
  
    override init() {
        super.init()
        self.cleanRootNote()
    }
    
    func makeCamera() -> SCNNode {
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 100, y: 75, z: 150)
        camera.zFar = 1000
        return cameraNode
    }
    

    func makeFloor() -> SCNNode {
        let floor = SCNFloor()
        floor.reflectivity = 0
        let floorNode = SCNNode()
        floorNode.geometry = floor
        return floorNode
    }
    
    func makeAmbientLight() -> SCNNode{
        let lightNode = SCNNode()
        let light = SCNLight()
        light.type = SCNLightTypeAmbient
        light.color = NSColor(white: 0.1, alpha: 1)
        lightNode.light = light
        return lightNode
    }
    
    func selecteNode(node: SCNNode)
    {
        self.selectedNode = node
    }

    
    func drawXY ()
    {
        let box1 = SCNBox(width: 500, height: 1, length: 1, chamferRadius: 0.0)
        let boxNode1 = SCNNode(geometry: box1)
        boxNode1.position = SCNVector3(x: 0, y: 0, z: 0)
        box1.firstMaterial?.diffuse.contents = NSColor.redColor()
        self.rootNode.addChildNode(boxNode1)
        
        let myText = SCNText(string: "Lack of Diversity", extrusionDepth: 1)
        myText.font = NSFont(name: "Arial", size: 8)
        myText.firstMaterial?.diffuse.contents = NSColor.redColor()
        let myTextNode = SCNNode(geometry: myText)
        myTextNode.position = SCNVector3(x: 105, y: -10, z: 0)
        self.rootNode.addChildNode(myTextNode)
        
        let box2 = SCNBox(width: 1, height: 500, length: 1, chamferRadius: 0.0)
        let boxNode2 = SCNNode(geometry: box2)
        boxNode2.position = SCNVector3(x: 0, y: 0, z: 0)
        box2.firstMaterial?.diffuse.contents = NSColor.greenColor()
        self.rootNode.addChildNode(boxNode2)
        
        let myText2 = SCNText(string: "Clumping", extrusionDepth: 1)
        myText2.font = NSFont(name: "Arial", size: 8)
        myText2.firstMaterial?.diffuse.contents = NSColor.greenColor()
        let myTextNode2 = SCNNode(geometry: myText2)
        myTextNode2.position = SCNVector3(x: -3, y: 40, z: 0)
        myTextNode2.rotation = SCNVector4(x: 0.0, y: 0.0, z: 1.0, w: CGFloat(M_PI / 2.0))
        self.rootNode.addChildNode(myTextNode2)
        
        if GlobalSearchSettings.NumberOfObjectives == 3
        {

        let box3 = SCNBox(width: 1, height: 1, length: 500, chamferRadius: 0.0)
        let boxNode3 = SCNNode(geometry: box3)
        boxNode3.position = SCNVector3(x: 0, y: 0, z: 0)
        box3.firstMaterial?.diffuse.contents = NSColor.blueColor()
        self.rootNode.addChildNode(boxNode3)
    
        let myText3 = SCNText(string: "Exits", extrusionDepth: 1)
        myText3.font = NSFont(name: "Arial", size: 8)
        myText3.firstMaterial?.diffuse.contents = NSColor.blueColor()
        let myTextNode3 = SCNNode(geometry: myText3)
        myTextNode3.position = SCNVector3(x: 0, y: -10, z: -40)
        myTextNode3.rotation = SCNVector4(x: 0.0, y: 1.0, z: 0.0, w: CGFloat(M_PI / 2.0))
        // myTextNode2.orientation = SCNQuaternion(x: 0.0, y: 0.5, z: 0.0, w: 0)
        self.rootNode.addChildNode(myTextNode3)
        }
        
    }
    func addYYIndividual(ind ind: YYIndividual)
    {
            if ind.rank == 1
            {
                //let sphereGeometry = SCNSphere(radius: 2)
                let box = SCNBox(width: 1.2, height: 1.2, length: 1.2, chamferRadius: 0.0)
                //let sphereNode = SCNNode(geometry: sphereGeometry)
                let boxNode = ParetoNode(geometry: box, ind: ind)
                
                var x : CGFloat
                var y : CGFloat
                var z : CGFloat
                if GlobalSearchSettings.NumberOfObjectives == 3
                {
                    x = CGFloat(ind.obj[0]) - 20.0
                    y = CGFloat(ind.obj[1])  / 3.0 - 10.0
                    z = CGFloat(ind.obj[2])  - 80.0
                }
                else
                {
                    x = CGFloat(ind.obj[0])  - 20.0
                    y = CGFloat(ind.obj[1])  / 3.0 - 10.0
                    z = 0.0
                }
                
                
                if  x < xMin
                {
                    xMin =  x
                }
                if x > xMax
                {
                    xMax =  x
                }
                
                if y < yMin
                {
                    yMin =  y
                }
                
                if  y > yMax
                {
                    yMax =  y
                }
                
                if z < zMin
                {
                    zMin = z
                }
                if z > zMax
                {
                    zMax = z
                }
                
                
                boxNode.position = SCNVector3(x: x, y: y, z: -z )
                box.firstMaterial?.diffuse.contents = NSColor.redColor()
                
                
                self.rootNode.addChildNode(boxNode)
                
        }
        
    }
    
    
    func addHumanIndividual(ind ind: YYIndividual)
    {
        
        let box = SCNSphere(radius: 2)
            let boxNode = ParetoNode(geometry: box, ind: ind)
            
            var x : CGFloat
            var y : CGFloat
            var z : CGFloat
        if GlobalSearchSettings.NumberOfObjectives == 3
        {
            x = CGFloat(ind.obj[0]) - 20.0
            y = CGFloat(ind.obj[1])  / 3.0 - 10.0
            z = CGFloat(ind.obj[2])  - 80.0
        }
        else
        {
            x = CGFloat(ind.obj[0])  - 20.0
            y = CGFloat(ind.obj[1])  / 3.0 - 10.0
            z = 0.0
        }
        

        
            boxNode.position = SCNVector3(x: x, y: y, z: -z )
            box.firstMaterial?.diffuse.contents = NSColor.greenColor()

            self.rootNode.addChildNode(boxNode)
       }


    func addYYPopulation(pop pop: YYPopulation)
    {
      
        var currNodes = self.rootNode.childNodes 
        
        var numDefaultNodes = 7
        
        if GlobalSearchSettings.NumberOfObjectives == 3
        {
            numDefaultNodes = 7

        }
        else if  GlobalSearchSettings.NumberOfObjectives == 2
        {
            numDefaultNodes = 5
        }
            
        for i in numDefaultNodes..<currNodes.count
        {
            let r:SCNNode = currNodes[i]
            if let geo = r.geometry  {
               geo.firstMaterial?.diffuse.contents = NSColor.grayColor()
            }
        }

        for ind in pop.individuals
        {
            self.addYYIndividual(ind: ind)
        }
    }
    
    func cleanRootNote()
    {
        let currNodes = self.rootNode.childNodes 
        
        for r:SCNNode in currNodes
        {
           r.removeFromParentNode()
        }
        
        self.cameraNode = self.makeCamera()
  
        self.rootNode.addChildNode(self.cameraNode!)
        
        self.drawXY()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}