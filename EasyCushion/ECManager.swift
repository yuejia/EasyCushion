//
//  ECManager.swift
//  EasyCushion
//
//  Created by Yue Jia on 09/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class ECManager
{
    var authors: [Int:Author] = [Int:Author]()
    var papers:  [Int:Paper] = [Int:Paper]()
    var reviewers: [Int:Reviewer] = [Int:Reviewer]()
    
    var discussionPapers = [Int]()
    var CSVDirectoryURL: NSURL?
    var progressManager =  YYProgressController.sharedController()
    
    init(ECPath: String)
    {
        self.CSVDirectoryURL = NSURL(fileURLWithPath: ECPath)
        
        
        self.progressManager.maxProgress = 100.0
        self.progressManager.status = "Loading Papers..."
        self.progressManager.currProgress = 30.0
        self.loadPapers()
        self.progressManager.maxProgress = 100.0
        self.progressManager.status = "Loading Reviewers..."
        self.progressManager.currProgress = 40.0
        self.loadReviews()
        self.progressManager.maxProgress = 100.0
        self.progressManager.status = "Loading Conflicts..."
        self.progressManager.currProgress = 80.0
        self.loadConficts()

        self.progressManager.maxProgress = 100.0
        self.progressManager.status = "Loading Leaders..."
        self.progressManager.currProgress = 90.0
        self.loadLeaders()
        
        self.progressManager.maxProgress = 100.0
        self.progressManager.status = "Loading Complete"
        self.progressManager.currProgress = 100.0


        GlobalSearchSettings.IndividualChromosomeSize = self.papers.count
        
        
       // self.generateDiscussionOrder()
        self.prepareConflictTable()
        
        for (_,v) in self.papers
        {
            v.computeOutcome()
        }

    }
    
    
    // No need to use it for seat generation
    func linkAuthorToPaper(authorId authorId: Int, toPaper paperId: Int, isCorresponding: Bool )
    {
        if let paper = self.papers[paperId]
        {
           // paper.addAuthor(self.authors[authorId]!)
        }
        else
        {
            YYLogger.error("assignAuthor: Cannot find paperID")
        }
    }
    

    // save a list of paper ids
    func savePaperId(filer filter: String, path: String, name: String)
    {
        var src = ""
        for (k, _) in self.papers
        {
            if filter != ""
            {
                if filter == self.papers[k]?.decision
                {
                     src += "\(self.papers[k]?.easyChairID)"
                }
            }
            else
            {
                src += "\(self.papers[k]?.easyChairID)"
            }
        }
        YYFile.saveStringToFile(src, path: path, name: name)
    }
    
    func addReviewerToPaper(reviewerId reviewerId : Int, paperId: Int, score: Int)
    {
        if let paper = self.papers[paperId]
        {
            if let reviewer = self.reviewers[reviewerId]
            {
                paper.addReviewer(reviewerId)
                paper.addScore(score)
            }
            else
            {
                YYLogger.error("addReviewerToPaper: Cannot find reviewerId")
            }
        }
        else
        {
             YYLogger.error("addReviewerToPaper: Cannot find paperID")
        }
    }

    func addReviewer(reviewerId reviewerId : Int,
        name: String)
    {
        if let reviewer = self.reviewers[reviewerId]
        {
            // Skip if reviewer exist
        }
        else
        {
             self.reviewers[reviewerId] = Reviewer(reviewerId: reviewerId, name: name)
        }
    }
    
    func addPaper(paperId paperId: Int,
        title: String,
        decision: String)
    {
        self.papers[paperId] = Paper(paperId: paperId, title: title, decision: decision)
    }
    
    func addAuthor(personId personId: Int,
        firstname: String,
        lastname: String,
        email: String,
        country: String,
        organization: String,
        website: String)
    {
        if let author = self.authors[personId]
        {
            //skip if the author exists
        }
        else
        {
            self.authors[personId]=Author(personId: personId ,
                firstname: firstname ,
                lastname: lastname ,
                email: email ,
                country: country ,
                organization: organization ,
                website: website)
        }
    }
    
    // load EC author.csv file
    func loadAuthors ()
    {
        let authorFile = "author.csv"
        let authorURL = self.CSVDirectoryURL?.URLByAppendingPathComponent(authorFile)
        
        if let url = authorURL {
            let error: NSErrorPointer = nil
            do {
                let csv = try YYCSVFile(contentsOfURL: url)
                
                let rows = csv.rows
                YYLogger.debug(csv.headers)
                for r in rows
                {
                    var text = (r["\"first name\""]!)
                    let firstname = YYString.stringReplace(string: text, oldValue: "\"", newValue: "")
                    YYLogger.debug(firstname)
                    
                    text = (r["\"last name\""]!)
                    let lastname = YYString.stringReplace(string: text, oldValue: "\"", newValue: "")
                    YYLogger.debug(lastname)
                    
                    let email = (r["email"]!)
                    YYLogger.debug(email)
                    
                    text = (r["country"]!)
                    let country = YYString.stringReplace(string: text, oldValue: "\"", newValue: "")
                    YYLogger.debug(country)
                    
                    text = (r["organization"]!)
                    let organization = YYString.stringReplace(string: text, oldValue: "\"", newValue: "")
                    YYLogger.debug(organization)
                    
                    text = (r["\"Web site\""]!)
                    let website = YYString.stringReplace(string: text, oldValue: "\"", newValue: "")
                    YYLogger.debug(website)
                    
                    text = (r["\"person #\""]!)
                    let personId = Int(text)!
                    YYLogger.debug(personId)
                    
                    text = (r["\"submission #\""]!)
                    let paperId = Int(text)!
                    YYLogger.debug(paperId)
                    
                    text = (r["corresponding?"]!)
                    let isCorresponding = YYString.stringToBool(string: text)
                    YYLogger.debug(isCorresponding)
                    
                    
                    self.addAuthor(personId: personId, firstname: firstname, lastname: lastname, email: email, country: country, organization: organization, website: website)
                    
                    self.linkAuthorToPaper(authorId: personId, toPaper: paperId, isCorresponding:  isCorresponding)
                    
                }
                
            } catch let error1 as NSError {
                error.memory = error1
            }
        }
    }
    
    // load EC review.csv file
    func loadReviews()
    {
        let paperFile = "review.csv"
        let paperURL = self.CSVDirectoryURL?.URLByAppendingPathComponent(paperFile)
        if let url = paperURL {
            let error: NSErrorPointer = nil
            do {
                let csv = try YYCSVFile(contentsOfURL: url)
                
                let rows = csv.rows
                YYLogger.info(csv.headers)
                for r in rows
                {
                    var text = (r["\"member #\""]!)
                    let reviewerId = Int(text)!
                    YYLogger.debug(reviewerId)
          
                    let reviewerName = (r["\"member name\""]!)
                    let name = YYString.stringReplace(string: reviewerName, oldValue: "\"", newValue: "")
                    YYLogger.debug(name)
                    
                    let scoresRawText = (r["scores"]!)
                    let scoresText: String = scoresRawText.characters.split {$0 == " "}.map { String($0) } [2]
                    let score: Int = Int(scoresText)!
                    YYLogger.debug(score)
                    
                    text = (r["\"submission #\""]!)
                    let paperId = Int(text)!
                    YYLogger.debug(paperId)
                    
                    self.addReviewer(reviewerId: reviewerId, name: name)
                    self.addReviewerToPaper(reviewerId: reviewerId, paperId: paperId, score: score)
                }
            } catch let error1 as NSError {
                error.memory = error1
            }
        }
        
    }
    
    // load EC confict.csv file
    func loadConficts()
    {
        let paperFile = "conflict.csv"
        let paperURL = self.CSVDirectoryURL?.URLByAppendingPathComponent(paperFile)
        if let url = paperURL {
            let error: NSErrorPointer = nil
            do {
                let csv = try YYCSVFile(contentsOfURL: url)
                
                let rows = csv.rows
                YYLogger.info(csv.headers)
                for r in rows
                {
                    var text = (r["\"member #\""]!)
                    let reviewerId = Int(text)!
                    YYLogger.debug(reviewerId)
                    
                    let reviewerName = (r["\"member name\""]!)
                    let name = YYString.stringReplace(string: reviewerName, oldValue: "\"", newValue: "")
                    YYLogger.debug(name)
                    
                    text = (r["\"submission #\""]!)
                    let paperId = Int(text)!
                    YYLogger.debug(paperId)
                    
                    //self.reviewers[reviewerId]?.addConflict(paperId)
                    self.papers[paperId]?.addConflict(reviewerId)
                }
            } catch let error1 as NSError {
                error.memory = error1
            }
        }

    }
    
    // load EC leader file and set discussion order template
    func loadLeaders()
    {
        
        let paperFile = "leaders.txt"
        let paperURL = self.CSVDirectoryURL?.URLByAppendingPathComponent(paperFile)
        let leaderDict = YYFile.loadTextFileToDictionary(paperURL!.path!, splitBy : "\t")
        for (k,v) in leaderDict
        {
            let paper = self.papers[Int(k)!]
            paper!.addLeader(self.searchForReviewer(v))
            print(v)
            self.discussionPapers.append(Int(k)!)
        }
    }
    
    // load EC submission.csv file
    func loadPapers()
    {
        let paperFile = "submission.csv"
        let paperURL = self.CSVDirectoryURL?.URLByAppendingPathComponent(paperFile)
        
        if let url = paperURL {
            let error: NSErrorPointer = nil
            do {
                let csv = try YYCSVFile(contentsOfURL: url)

                let rows = csv.rows
                YYLogger.debug(csv.headers)
                for r in rows
                {
                    let text = (r["#"]!)
                    let paperId = Int(text)!
                    YYLogger.debug(paperId)
                    
                    let title = (r["title"]!)
                    YYLogger.debug(title)
                    
                    let decision = (r["decision"]!)
                    YYLogger.debug(decision)
                   
                    self.addPaper(paperId: paperId, title: title, decision: decision)
                }
                
            } catch let error1 as NSError {
                error.memory = error1
            }
        }
    }
    
    func prepareConflictTable()
    {
        for k in self.discussionPapers
        {
            let paper = self.papers[k]!
            
            let reviewers : [Int] = paper.reviewers
            for r in reviewers
            {
                let conficts : [Int] = paper.conflicts
                for c in conficts
                {
                    let reviewer = self.reviewers[r]!
                    reviewer.conflictedReviewers(c, paperId: paper.easyChairID)
                }
            }
        }
    }
    
    func searchForReviewer(name: String) -> Int
    {
        for (k,v) in self.reviewers
        {
            if  v.name == name
            {
                return k
            }
        }
        
        print(name)
        return -1
    }
}