//
//  Author.swift
//  EasyCushion
//
//  Created by Yue Jia on 09/05/2015.
//  Copyright (c) 2015 yueyuan.co.uk. All rights reserved.
//

import Foundation

class Author {
    var firstName: String = ""
    var lastName: String = ""
    var easyChairID: Int = 0
    var website: String = ""
    var organization : String = ""
    var country: String = ""
    var email : String = ""
    
    init(personId: Int,
        firstname: String,
        lastname: String,
        email: String,
        country: String,
        organization: String,
        website: String)
    {
        self.easyChairID = personId
        self.firstName = firstname
        self.lastName = lastname
        self.email = email
        self.country = country
        self.organization = organization
        self.website = website
    }
    
    
}