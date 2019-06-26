//
//  UserController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

class UserController {
    var bearer: Bearer?
    var user: User?
    private let baseURL = URL(string: "https://protected-temple-41202.herokuapp.com/users")!
    
    func loginWith(user: User, loginType: LoginType, completion: @escaping (Error?) -> ()) {
        let requestURL = baseURL.appendingPathComponent("\(loginType.rawValue)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("error encoding: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            if loginType == .signIn {
                guard let data = data else {
                    completion(NSError())
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                do {
                    self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
                    completion(nil)
                } catch {
                    print("error decoding data/token: \(error)")
                    completion(error)
                    return
                }
            }
            
            completion(nil)
            }.resume()
    }
    
    func getCurrentUser(for bearer: Bearer, completion: @escaping (Result<User, NetworkError>) -> ()) {
        let currentUserURL = baseURL.appendingPathComponent("current")
        var request = URLRequest(url: currentUserURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(bearer)
        } catch {
            print("error encoding: \(error)")
            completion(.failure(.noEncode))
            return
        }
        
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
                self.user = try jsonDecoder.decode(User.self, from: data)
                completion(.success(self.user!))
            } catch {
                completion(.failure(.noDecode))
            }
            }.resume()
    }
}
