//
//  DataService.swift
//  thecrazyweekend
//
//  Created by James DuBois on 3/12/16.
//  Copyright © 2016 James DuBois. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService() // creating a static variable only one instance in memory and make it globally accessible
    

    private var _REF_BASE = Firebase(url: "https://thecrazyweekend.firebaseio.com") // Reference to our FB account
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
}