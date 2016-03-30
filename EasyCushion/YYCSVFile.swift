//
//  YYCSVFile.swift
//  YYTools
//
//  Created by Yue Jia on 09/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//
//  Based on https://github.com/naoty/SwiftCSV/blob/master/SwiftCSV/CSV.swift
//
//  Log: May 9, 2015 add suppot for comma in quotation e.g. "a,b"

import Foundation

public class YYCSVFile {
    public var headers: [String] = []
    public var rows: [Dictionary<String, String>] = []
    public var columns = Dictionary<String, [String]>()
    var delimiter = NSCharacterSet(charactersInString: ",")
    var progressManager = YYProgressController.sharedController()
    
    
    public init(contentsOfURL url: NSURL, delimiter: NSCharacterSet, encoding: UInt) throws {
        let csvString: String?
        do {
            csvString = try String(contentsOfURL: url, encoding: encoding)
        } catch _ {
            csvString = nil
        };
        if let csvStringToParse = csvString {
            
            let csvCleanStringToParse = YYString.removeNewLineAndReturnInQuotation(string: csvStringToParse)
            
            self.delimiter = delimiter
            YYLogger.debug(csvCleanStringToParse)
            
            let newline = NSCharacterSet.newlineCharacterSet()
            var lines: [String] = []
            csvCleanStringToParse.stringByTrimmingCharactersInSet(newline).enumerateLines { line, stop in lines.append(line) }
            
            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
            self.columns = self.parseColumns(fromLines: lines)
        }
    }
    
    public convenience init(contentsOfURL url: NSURL) throws {
        let comma = NSCharacterSet(charactersInString: ",")
        try self.init(contentsOfURL: url, delimiter: comma, encoding: NSUTF8StringEncoding)
    }
    
    public convenience init(contentsOfURL url: NSURL, encoding: UInt) throws {
        let comma = NSCharacterSet(charactersInString: ",")
        try self.init(contentsOfURL: url, delimiter: comma, encoding: encoding)
    }
    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].componentsSeparatedByCharactersInSet(self.delimiter)
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        var rows: [Dictionary<String, String>] = []
        
        
        // IF GUI
        let gui = lines.count > 100
        if gui
        {
        progressManager.maxProgress = Double(lines.count)
        progressManager.status = "Parsing CSV File ..."
        }
        
        for (lineNumber, line) in lines.enumerate() {
            
            // IF GUI
            if gui
            {
            progressManager.increaseProgressByOne()
            }
            
            if lineNumber == 0 {
                continue
            }
            
            let newline = YYString.removeCommaInQuotation(string: line)
            YYLogger.debug(newline)
            var row = Dictionary<String, String>()
            let values = newline.componentsSeparatedByCharactersInSet(self.delimiter)
            for (index, header) in self.headers.enumerate() {
                let value = values[index]
                row[header] = value
            }
            rows.append(row)
        }
        
        return rows
    }
    
    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [String]> {
        var columns = Dictionary<String, [String]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header]! }
            columns[header] = column
        }
        
        return columns
    }
}