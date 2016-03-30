//
//  Presentation.swift
//  EasyCushion
//
//  Created by Yue Jia on 10/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//
//  Based on generate_slides.py - EasyChair slide generator.

import Foundation

class Presentation {
    var header : String
    var footer  : String
    var slide_xml  : String
    var new_slides   : String
    var num_slides = 0

    init(path: String)
    {
        self.header = YYFile.loadTextFile(path+"/header.tex")
        self.footer = YYFile.loadTextFile(path+"/footer.tex")
        self.slide_xml = YYFile.loadTextFile(path+"/slide.tex")
        self.new_slides = ""
    }
    
    func writeToFile(path: String)
    {
 
        YYLogger.info("Generating slides...")
        let src = "\(self.header)\n\(self.new_slides)\n\(self.footer)"
        YYFile.saveStringToFile(src, path: path, name: "presentation.tex")
        system("/usr/texbin/pdflatex \(path)/presentation.tex")
        system("mv presentation.pdf \(path)")
        system("rm presentation*")
    }
}