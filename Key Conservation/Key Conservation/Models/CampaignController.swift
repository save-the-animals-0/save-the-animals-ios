//
//  CampaignController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import UIKit

class CampaignController {
    let baseURL = URL(string: "https://protected-temple-41202.herokuapp.com/campaigns")!
    var campaignList: [Campaign] = []
    
    // fetch campaigns for all
    func fetchCampaigns(completion: @escaping (Result<[Campaign], NetworkError>) -> ()) {
        let request = URLRequest(url: baseURL)
        
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
                print("campaign decode failure")
            }
            }.resume()
    }
    
    // delete a campaign
    func deleteCampaign(campaign: Campaign, completion: @escaping (NetworkError?) -> ()) {
        guard let id = campaign.id else { return }
        let deleteURL = baseURL.appendingPathComponent(":\(id)")
        
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
                print(response.statusCode)
                return
            }
            
            completion(nil)
        }.resume()
        
    }
    
    // update a campaign
    func updateCampaign(campaign: Campaign, fundingGoal: Int, location: String, description: String, deadline: Date, urgencyLevel: String, species: String?, completion: @escaping (NetworkError?) -> ()) {
        guard let id = campaign.id else { return }
        let updatedCampaign = Campaign(id: id, campaignName: campaign.campaignName, fundingGoal: fundingGoal, location: location, description: description, deadline: deadline, urgencyLevel: urgencyLevel, species: "species", imageData: nil, imageURL: nil, fundingRaised: nil)
        let updateURL = baseURL.appendingPathComponent(":\(id)")
        
        var request = URLRequest(url: updateURL)
        request.httpMethod = HTTPMethod.put.rawValue
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(updatedCampaign)
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
    
    // add a campaign
    func addCampaign(campaign: Campaign, completion: @escaping (NetworkError?) -> ()) {
        var request = URLRequest(url: baseURL)
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
