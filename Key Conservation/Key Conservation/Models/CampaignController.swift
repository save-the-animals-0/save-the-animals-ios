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
    let token: String? = KeychainWrapper.standard.string(forKey: "token")
    
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
            jsonDecoder.dateDecodingStrategy = .customISO8601
            do {
                self.campaignList = try jsonDecoder.decode([Campaign].self, from: data)
                completion(.success(self.campaignList))
            } catch {
                print("\(error)")
                completion(.failure(.noDecode))
                print("campaign decode failure")
            }
            }.resume()
    }
    
    // delete a campaign
    func deleteCampaign(campaign: Campaign, completion: @escaping (NetworkError?) -> ()) {
        guard let id = campaign.id else { return }
        let deleteURL = baseURL.appendingPathComponent("\(id)")
        
        var request = URLRequest(url: deleteURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
    func updateCampaign(campaign: Campaign, fundingGoal: Double, location: String, description: String, deadline: Date, urgencyLevel: String, species: String, donationAmount: Double?, completion: @escaping (NetworkError?) -> ()) {
        guard let id = campaign.id else { return }
        var updatedCampaign = Campaign(id: nil, campaignName: campaign.campaignName, fundingGoal: fundingGoal, location: location, description: description, deadline: deadline, urgencyLevel: urgencyLevel, species: species, imageData: nil, imageURL: nil, fundingRaised: nil)
        
        if let newFundingRaised = donationAmount {
            updatedCampaign = Campaign(id: nil, campaignName: campaign.campaignName, fundingGoal: campaign.fundingGoal, location: campaign.location, description: campaign.description, deadline: campaign.deadline, urgencyLevel: campaign.urgencyLevel, species: campaign.species, imageData: nil, imageURL: nil, fundingRaised: newFundingRaised + (campaign.fundingRaised ?? 0))
        }
        
        let updateURL = baseURL.appendingPathComponent("\(id)")
        var request = URLRequest(url: updateURL)
        request.httpMethod = HTTPMethod.put.rawValue
        print(request)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print(token)
        }
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .customISO8601
        do {
            request.httpBody = try jsonEncoder.encode(updatedCampaign)
        } catch {
            print("error encoding: \(error)")
            completion(.noEncode)
            return
        }
        request.httpBody?.printJSON()
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let _ = error {
                completion(.otherError)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print(response)
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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .customISO8601
        do {
            request.httpBody = try jsonEncoder.encode(campaign)
        } catch {
            print("error encoding: \(error)")
            completion(.noEncode)
            return
        }
        
        request.httpBody?.printJSON()
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let _ = error {
                completion(.otherError)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("\(response)")
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

extension Data
{
    func printJSON()
    {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8)
        {
            print(JSONString)
        }
    }
}
