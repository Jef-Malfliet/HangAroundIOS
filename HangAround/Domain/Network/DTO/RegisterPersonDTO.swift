//
//  RegisterPersonDTO.swift
//  HangAround
//
//  Created by Jef Malfliet on 22/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import Foundation

struct RegisterPersonDTO: Codable {
    var name: String
    var email: String
    var friends: [String]
}
