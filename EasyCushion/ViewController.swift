//
//  ViewController.swift
//  EasyCushion
//
//  Created by Yue Jia on 09/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Cocoa
import SceneKit

var GlobalParetoSence : ParetoScence?
weak var  GlobalScnView: SCNView?
var GlobalECManager: ECManager?

class ViewController: NSViewController , NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var includeExitCheckBox: NSButton!

    @IBOutlet weak var numOfExitLabel: NSTextField!
    @IBOutlet weak var lackOfDiversityLabel: NSTextField!
    
    @IBOutlet weak var Clumping0Label: NSTextField!
    
    @IBOutlet weak var Clumping1Label: NSTextField!
    
    @IBOutlet weak var Clumping2Label: NSTextField!
    
    @IBOutlet weak var Clumping3Label: NSTextField!
    
    
    @IBOutlet weak var discussionOrderTableView: NSTableView!

    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var statusLabel: NSTextField!
    
    @IBOutlet weak var scnView: SCNView!
    
    
    var progressController = YYProgressController.sharedController()
    var manager : ECManager?
    var paretoSence : ParetoScence?
    var leaderGapArray : [Int]?
    var reviewerGapArray : [Int]?
    var reviewerExitArray: [Int]?
    var sbse:SBSE?
    var workingPath : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
// Do any additional setup after loading the view.
        
        if self.includeExitCheckBox.state == NSOnState
        {
            GlobalSearchSettings.NumberOfObjectives = 3
        }
        else
        {
            GlobalSearchSettings.NumberOfObjectives = 2
        }
        
        progressController.progressBar = self.progressBar
        progressController.statusLabel = self.statusLabel
        self.progressController.status = "Ready"

        self.paretoSence = ParetoScence()
        self.scnView.scene = self.paretoSence
        GlobalParetoSence = self.paretoSence
        
        //self.scnView.backgroundColor = NSColor.blackColor()
        scnView.autoenablesDefaultLighting = true
        GlobalScnView = self.scnView
        
        let nib = NSNib(nibNamed: "ColourTableCellView", bundle: NSBundle.mainBundle())
        self.discussionOrderTableView.registerNib(nib!, forIdentifier: "ColourTableCellView")
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    //UITapGestureRecognizer
    
    override func keyDown(theEvent: NSEvent) {
        let node = self.paretoSence!.rootNode.childNodes[0] as? SCNNode
        if theEvent.keyCode == 123
        {
            // left
            
            //node?.rotation = SCNVector4(x: 1, y: 0, z: 0, w: CGFloat(M_PI / 4))
           // node!.eulerAngles.x -= 0.1//CGFloat(M_PI / 8.0)
            node!.eulerAngles =  SCNVector3Make(CGFloat(M_PI_2), 0, 0)
          //  node!.eulerAngles.y -= CGFloat(M_PI / 8.0 * 3.0)
            print(node!.eulerAngles.x)
        }
        else if theEvent.keyCode == 124
        {
            node!.eulerAngles.y -= 0.1
        }
    }
    
    override func  mouseDown(theEvent: NSEvent) {
        
        print("Caught mouse event \(theEvent.locationInWindow)")
        
        let winp = theEvent.locationInWindow
        let p = self.scnView.convertPoint(winp, fromView: nil)
        
        let p2: CGPoint = CGPointMake(p.x, p.y)
        
        
        let results = self.scnView.hitTest(p2, options: [SCNHitTestFirstFoundOnlyKey: true]) 
        if let result = results.first {
            
             dispatch_async(dispatch_get_main_queue(), {
            self.paretoSence?.selecteNode(result.node)
                
                
            let ind = (result.node as! ParetoNode).individual as! DiscussionOrder
            self.leaderGapArray = ind.getLeaderGapArray()
            self.reviewerGapArray = ind.getReviewerGapArray()
            
            var r0 = 0
            var r1 = 0
            var r2 = 0
            var r3 = 0
                
            var l0 = 0
            var l1 = 0
            var l2 = 0
            var l3 = 0
                
            for r in self.reviewerGapArray!
            {
                if r == 0
                {
                    r0 += 1
                }
                    
                if r <= 1
                {
                    r1 += 1
                }
                
                if r <= 2
                {
                    r2 += 1
                }
                
                if r<=3
                {
                    r3 += 1
                }
            }
                
                for r in self.leaderGapArray!
                {
                    if r == 0
                    {
                        l0 += 1
                    }
                    
                    if r <= 1
                    {
                        l1 += 1
                    }
                    
                    if r <= 2
                    {
                        l2 += 1
                    }
                    
                    if r<=3
                    {
                        l3 += 1
                    }
                }
                
            
                
            //println(self.leaderGapArray)
            self.reviewerExitArray = ind.getReviewerExitArray()
                
            self.discussionOrderTableView.reloadData()
            self.discussionOrderTableView.needsDisplay = true
                
            if    let ind = (result.node as! ParetoNode).individual
            {
                var positive : Int
                var negtive : Int
                (positive , negtive) = (ind as! DiscussionOrder).checkConnectedPaper()
                self.lackOfDiversityLabel.stringValue = "# Diversity: Positive \(positive), Negtive  \(negtive)"
                self.Clumping0Label.stringValue = "# 0 - Clumping: Leader: \(l0), Reviewer: \(r0)"
                self.Clumping1Label.stringValue = "# 1 - Clumping: Leader: \(l1), Reviewer: \(r1)"
                self.Clumping2Label.stringValue = "# 2 - Clumping: Leader: \(l2), Reviewer: \(r2)"
                self.Clumping3Label.stringValue = "# 3 - Clumping: Leader: \(l3), Reviewer: \(r3)"
                self.numOfExitLabel.stringValue = "# Exits: \(ind.obj[2])"
                
                
            }
                
            })
            
        }
        
    }

    @IBAction func toggleCamera(sender: AnyObject) {
        let btn = sender as! NSButton
        
      
        if btn.state == NSOnState
        {
          scnView.allowsCameraControl  =  true
            btn.title = "Lock"
        }
        else
        {
            scnView.allowsCameraControl  =  false
        //    self.scnView.pointOfView = self.paretoSence?.rootNode.childNodes[0] as? SCNNode
             btn.title = "Unlock"
        }
        
    }
    
    @IBAction func saveCurrentIndividual(sender: AnyObject)
    {
        var str = ""
        if let node = self.paretoSence?.selectedNode
        {
            if let ind = (node as! ParetoNode).individual
            {
                for i in 0..<GlobalSearchSettings.IndividualChromosomeSize
                {
                    let paper = ind.chromosome[i] as! Paper
                    if paper.reviewers.count > 0
                    {
                        let name = self.manager?.reviewers[paper.leader]!.name
                        str += "\(paper.easyChairID)\t\(name!)\n"
                    }
                    else
                    {
                        str += "\(paper.easyChairID)\tUnknown\n"
                    }
                }
            }
        }
        
        YYFile.saveStringToFile(str, path: self.workingPath!, name: "SBSE_DiscussionOrder.txt")
    }
  
    /*
    @IBAction func tapped(g:) {
        let results = self.scnView.hitTest(g.locationInView (scnView), options: [SCNHitTestFirstFoundOnlyKey: true]) as [SCNHitTestResult]
        if let result = results.first {
            if result.node === self.scene.pegs[0] {
                println("Peg nr. 1 selected.")
            }
        }
    }
    */

    @IBAction func loadData(sender: AnyObject) {

        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = false
        
        let fileHandler: (Int) -> (Void) =
        {
            result in
            if result == NSFileHandlingPanelOKButton {
                
                let url = openPanel.URL
                self.workingPath = url?.path
                let path = url?.absoluteString
             
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                    self.manager = ECManager(ECPath: path!)
                    
                    GlobalECManager = self.manager
                    self.sbse = SBSE(reviewers: self.manager!.reviewers, papers:self.manager!.papers, discussionPaper: self.manager!.discussionPapers)
                    
                })

                
            }
            
        }
        let window = NSApplication.sharedApplication().windows[0] 
        openPanel.beginSheetModalForWindow(window, completionHandler: fileHandler)

        
        
        
        
        //var path = "/Users/yuejia/Dropbox/Projects/Swift_Projects/EasyCushion/ESEC_FSE 2015_data_EasyChair_2015-05-14"
        
        
        
        
      
    }
    
    @IBAction func generateSlides(sender: AnyObject) {

        if self.includeExitCheckBox.state == NSOnState
        {
            GlobalSearchSettings.NumberOfObjectives = 3
        }
        else
        {
            GlobalSearchSettings.NumberOfObjectives = 2
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            self.sbse!.startEvolution()
        })
    }
    @IBAction func resetCamera(sender: AnyObject) {
        
       self.scnView.pointOfView = self.paretoSence!.rootNode.childNodes[0] as? SCNNode
       /*
        if let node = self.paretoSence?.selectedNode
        {
            let constraint = SCNLookAtConstraint(target: (node))
                constraint.gimbalLockEnabled = true
                self.scnView.pointOfView!.constraints = [constraint]
                self.scnView.pointOfView!.camera!.usesOrthographicProjection = true
        }
    */
    }
    
    
    // mark NSTable View for Settings
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int
    {
     
        if let selected = self.paretoSence?.selectedNode as? ParetoNode
        {
            return GlobalSearchSettings.IndividualChromosomeSize
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 8
    }
    
   // func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?
     func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    
        
        let cell = tableView.makeViewWithIdentifier("ColourTableCellView", owner: self) as! ColourTableCellView
        
        cell.imageView.image = nil
        cell.numberLabel.stringValue = ""
        if let selected = self.paretoSence?.selectedNode as? ParetoNode
        {
            let chromosome = selected.individual?.chromosome
            if tableColumn!.identifier == "paper"
            {
                    if let paper = chromosome![row] as? Paper
                    {
                        if paper.outcome == 1
                        {
                            cell.imageView.image = NSImage(named: "btnGreen")

                        }
                        else if paper.outcome == -1
                        {
                            cell.imageView.image = NSImage(named: "btnRed")
                            
                        }
                            /*
                        else if paper.outcome == 0
                        {
                           //  cell.imageView.image = NSImage(named: "btnBlue")
                        }
                            */
                        return cell
                    }
            }
            else if tableColumn!.identifier == "g0"
            {
                if self.leaderGapArray![row] == 0 && self.reviewerGapArray![row] == 0
                {
                    cell.imageView.image = NSImage(named: "btnBlack")
                }
                
                else if self.leaderGapArray![row] == 0
                {
                    cell.imageView.image = NSImage(named: "btnDarkGray")
                }
                else if self.reviewerGapArray![row] == 0
                {
                    cell.imageView.image = NSImage(named: "btnGray")
                }
                
                return cell
            }
            
            else if tableColumn!.identifier == "g1"
            {
                if self.leaderGapArray![row] <= 1  && self.reviewerGapArray![row] <= 1
                {
                    cell.imageView.image = NSImage(named: "btnBlack")
                }
                    
                else if self.leaderGapArray![row] <= 1
                {
                    cell.imageView.image = NSImage(named: "btnDarkGray")
                }
                else if self.reviewerGapArray![row] <= 1
                {
                    cell.imageView.image = NSImage(named: "btnGray")
                }
                
                return cell
            }
            
            else if tableColumn!.identifier == "g2"
            {
                if self.leaderGapArray![row] <= 2  && self.reviewerGapArray![row] <= 2
                {
                    cell.imageView.image = NSImage(named: "btnBlack")
                }
                    
                else if self.leaderGapArray![row] <= 2
                {
                    cell.imageView.image = NSImage(named: "btnDarkGray")
                }
                else if self.reviewerGapArray![row] <= 2
                {
                    cell.imageView.image = NSImage(named: "btnGray")
                }
                return cell
            }
            
            else if tableColumn!.identifier == "g3"
            {
                if self.leaderGapArray![row] <= 3  && self.reviewerGapArray![row] <= 3
                {
                    cell.imageView.image = NSImage(named: "btnBlack")
                }
                    
                else if self.leaderGapArray![row] <= 3
                {
                    cell.imageView.image = NSImage(named: "btnDarkGray")
                }
                else if self.reviewerGapArray![row] <= 3
                {
                    cell.imageView.image = NSImage(named: "btnGray")
                }
                
                return cell
            }
            else  if tableColumn!.identifier == "exit"
            {
                if self.reviewerExitArray![row] == 0
                {
                    return nil
                }
                if self.reviewerExitArray![row] <= 3
                {
                    cell.imageView.image = NSImage(named: "btnGray")
                }
                else if self.reviewerExitArray![row] <= 6
                {
                     cell.imageView.image = NSImage(named: "btnDarkGray")
                }
                else
                {
                     cell.imageView.image = NSImage(named: "btnBlack")
                }
                
                return cell
            }
            
        }
        
               return nil
    }
    @IBAction func loadHumanSolution(sender: AnyObject) {
        let solution = YYFile.loadTextFileToArray("\(workingPath!)/Human_Solution.txt", splitBy: "\t")
        let ind = DiscussionOrder()
        
        for l in 0..<solution.count
        {
            let pid = Int(solution[l][0])
            ind.chromosome.append(self.manager!.papers[pid!]!)
        }
        
        ind.evaluateFitness()
        
        self.paretoSence?.addHumanIndividual(ind: ind)
        
        print("obj1: \(ind.obj[0]), obj2: \(ind.obj[1]), obj3: \(ind.obj[2]) \n")
        

            dispatch_async(dispatch_get_main_queue(), {
                GlobalScnView?.needsDisplay = true
            })
    
        
    }
    
}

