//
//  Activity.swift
//  HangAround
//
//  Created by Jef Malfliet on 09/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import Foundation

struct Activity: Codable {
    var id: String = ""
    var name: String
    var owner: String = Auth0Manager.instance.person!.id
    var startDate: Date = Date()
    var endDate: Date = Date()
    var place: String = ""
    var participants: [PersonWithRole?] = []
    var description: String = ""
    
    init(name: String) {
        self.name = name
    }
    
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
    
    mutating func toDTO() -> ActivityDTO{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        if(startDate < Date()){
            self.startDate = Date()
        }
        
        if(startDate < endDate){
            self.endDate = self.startDate
        }
        
        return ActivityDTO(id: id, name: name, owner: owner, startDate: formatter.string(from: startDate), endDate: formatter.string(from: endDate), place: place, participants: participants, description: description)
    }
}

struct PersonWithRole: Codable, Equatable {
    var personId: String
    var role: String
}

