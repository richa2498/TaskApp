//
//  tasks.swift
//  Richa_764947_FA2
//
//  Created by Richa Patel on 2020-01-20.
//  Copyright © 2020 Richa Patel. All rights reserved.
//

import Foundation

class Tasks{
    internal init(title: String, desc: String, date: Date, noOfDays: Int, isDone: Bool) {
        self.title = title
        self.desc = desc
        self.date = date
        self.noOfDays = noOfDays
        self.isDone = isDone
    }
    
    
    var title : String
    var desc : String
    var date : Date
    var noOfDays : Int
    var isDone : Bool
    
}
