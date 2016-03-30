//
//  YYProgressBarController.swift
//  YYTools
//
//  Created by Yue Jia on 10/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Cocoa

var GlobalProgressController = YYProgressController()
class YYProgressController
{
    weak var progressBar: NSProgressIndicator!
    weak var statusLabel: NSTextField!

    var maxProgress: Double = 1.0
    {
        didSet{
            if self.progressBar != nil
            {
            dispatch_async(dispatch_get_main_queue(), {
                self.progressBar.maxValue = self.maxProgress
            })
            self.currProgress = 0.0
            }
        }
    }
    
    func increaseProgressByOne()
    {
        
        self.currProgress = self.currProgress + 1
 
    }
    
    var status: String = ""
        {
        didSet{
            if self.statusLabel != nil
            {
            dispatch_async(dispatch_get_main_queue(), {
            self.statusLabel.stringValue = self.status
            })
            }
        }
    }
    
    var currProgress : Double = 0.0
        {
        didSet{
            if self.progressBar != nil
            {
            dispatch_async(dispatch_get_main_queue(), {
            self.progressBar.doubleValue = self.currProgress
            })
            }
        }
    }
    
    class func sharedController() -> YYProgressController
    {
        return GlobalProgressController
    }
}
