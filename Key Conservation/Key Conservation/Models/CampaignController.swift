//
//  CampaignController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import UIKit

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
}

class CampaignController: Codable {
    // Add api base URL
    // Placeholder
    let baseURL = URL(string: "https://")!
    var campaignList: [Campaign] = []
    
    // fetch campaigns for all or search
    func fetchCampaigns(for search: String?, completion: @escaping (Result<[Campaign], NetworkError>) -> ()) {
        let searchURL: URL
        
        if let search = search {
            searchURL = baseURL.appendingPathComponent("\(search)")
        } else {
            searchURL = baseURL
        }
        let request = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                self.campaignList = try jsonDecoder.decode([Campaign].self, from: data)
                completion(.success(self.campaignList))
            } catch {
                completion(.failure(.noDecode))
            }
            }.resume()
    }
    
    func deleteCampaign(campaign: Campaign) {
        // function stub
    }
    
    func updateCampaign(campaign: Campaign) {
        // function stub
    }
    
    func addCampaign(campaign: Campaign) {
        // function stub
    }
    
    // image fetch function
    func fetchImage(at urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
        let imageURL = URL(string: urlString)!
        let request = URLRequest(url: imageURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let image = UIImage(data: data)!
            completion(.success(image))
            }.resume()
    }
    
}
