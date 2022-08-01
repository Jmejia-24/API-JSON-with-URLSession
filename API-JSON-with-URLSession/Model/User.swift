//
//  User.swift
//  API-JSON-with-URLSession
//
//  Created by Byron Mejia on 7/31/22.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}
