//
//  Country.swift
//  Concurrency
//
//  Created by Oscar Victoria Gonzalez  on 12/6/19.
//  Copyright © 2019 Oscar Victoria Gonzalez . All rights reserved.
//

import Foundation

struct Country: Decodable {
    let name: String
    let population: Int
    let capital: String
    let alpha2Code: String
    let flag: String
}

