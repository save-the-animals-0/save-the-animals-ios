//
//  NetworkHelpers.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case otherError
    case badData
    case noDecode
    case noEncode
    case badResponse
}

struct Bearer: Codable {
    let token: String
}

enum LoginType: String {
    case signUp = "signup" //placeholder
    case signIn = "login" //placeholder
}
