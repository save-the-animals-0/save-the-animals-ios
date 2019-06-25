//
//  CampaignController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import UIKit

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
    
    func deleteCampaign(campaign: Campaign, completion: @escaping (NetworkError?) -> ()) {
        
        let deleteURL = baseURL.appendingPathComponent("delete") //placeholder
        
        var request = URLRequest(url: deleteURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(campaign)
        } catch {
            print("error encoding: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let _ = error {
                completion(.otherError)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.badResponse)
                return
            }
            
            completion(nil)
        }.resume()
        
    }
    
    func updateCampaign(campaign: Campaign, completion: @escaping (NetworkError?) -> ()) {
        // function stub
        let updateURL = baseURL.appendingPathComponent("update/\(campaign)") //placeholder
        
        var request = URLRequest(url: updateURL)
        request.httpMethod = HTTPMethod.put.rawValue
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(campaign)
        } catch {
            print("error encoding: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let _ = error {
                completion(.otherError)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.badResponse)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    func addCampaign(campaign: Campaign, completion: @escaping (NetworkError?) -> ()) {
        // function stub
        
        let updateURL = baseURL.appendingPathComponent("add") //placeholder
        
        var request = URLRequest(url: updateURL)
        request.httpMethod = HTTPMethod.post.rawValue
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(campaign)
        } catch {
            print("error encoding: \(error)")
            completion(.noEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let _ = error {
                completion(.otherError)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.badResponse)
                return
            }
            
            completion(nil)
            }.resume()
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
