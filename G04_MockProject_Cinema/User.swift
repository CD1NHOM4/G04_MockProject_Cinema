//
//  User.swift
//  G04_MockProject_Cinema
//
//  Created by THANH on 6/5/17.
//  Copyright © 2017 HCMUTE. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    
    var fullName: String
    var email: String
    var address: String
    var balance: Double
    var password: String
    var phone: String
    var uid: String
    
    init(fullName: String, email: String, address: String, balance: Double,
         password: String, phone: String, uid: String) {
        self.fullName = fullName
        self.email = email
        self.address = address
        self.balance = balance
        self.password = password
        self.phone = phone
        self.uid = uid
    }
    
    convenience override init() {
        self.init(fullName: "",email: "", address: "", balance: 0, password: "",
                  phone: "", uid: "")
    }
}
