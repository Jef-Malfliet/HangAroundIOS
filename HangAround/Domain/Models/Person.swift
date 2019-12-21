//
//  Person.swift
//  HangAround
//
//  Created by Jef Malfliet on 09/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import Foundation

struct Person: Codable {
    let id: String
    let name: String
    let email: String
    let friends: [String?]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case friends
    }
}
