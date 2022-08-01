//
//  Address.swift
//  API-JSON-with-URLSession
//
//  Created by Byron Mejia on 8/1/22.
//

import Foundation

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}
