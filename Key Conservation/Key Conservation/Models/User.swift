//
//  User.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: String
    let password: String
    let email: String
    let imageURL: String?
    let imageData: Data?
    // let campaignsSupported: [String]
}
