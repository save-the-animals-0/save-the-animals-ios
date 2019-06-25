//
//  Campaign.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

struct Campaign: Codable {
    let title: String
    let location: String
    let description: String
    let imageURL: String?
    let fundingRaised: String?
    let fundingGoal: String
    let deadline: String
    let category: String
    let imageData: Data?
}
