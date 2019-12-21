//
//  ActivityDTO.swift
//  HangAround
//
//  Created by Jef Malfliet on 19/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import Foundation

struct ActivityDTO: Codable {
    var id: String
    var name: String
    var owner: String
    var startDate: String
    var endDate: String
    var place: String
    var participants: [PersonWithRole?]
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case owner
        case startDate
        case endDate
        case place
        case participants
        case description
    }
}
