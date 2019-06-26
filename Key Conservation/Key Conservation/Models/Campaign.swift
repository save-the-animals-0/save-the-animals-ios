//
//  Campaign.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

struct Campaign: Codable {
    let id: String?
    let campaignName: String
    let fundingGoal: String
    let location: String
    let description: String
    let deadline: String
    let urgencyLevel: String
    let species: String?
    let imageData: Data?
    let imageURL: String?
    let fundingRaised: String?
}
