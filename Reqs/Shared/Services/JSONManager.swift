//
//  NetworkManager.swift
//  Reqs
//
//  Created by Joseph Gilmore on 6/9/22.
//

import UIKit
import CoreLocation

struct JSONManager {
    
    let constants = Constant()
    
    //MARK: - Perform Request / Parse JSON
    func performRequest<T:Decodable>(with urlString: String, completion: @escaping (Result<T, Error>) -> ()) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = ["Authorization": "Bearer \(constants.apiKey)"]
            
            let task = session.dataTask(with: request) {  data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let safeData = data {
                    if let yelpData = self.parseJSON(safeData) as T? {
                        completion(.success(yelpData))
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON<T:Decodable>(_ yelpData: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedData = try decoder.decode(T.self, from: yelpData)
            return decodedData
        }
        catch {
            print(error)
            return nil
        }
    }
    
  //MARK: - Fetch Functions
  
  func fetchYelpResults(term: String, location: CLLocation, completion: @escaping (Result<YelpResult, Error>) -> ()) {
      let url = "https://api.yelp.com/v3/businesses/search?term=\(term)&latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)"
      performRequest(with: url, completion: completion)
  }
  
    func fetchHotResults(location: CLLocation, completion: @escaping (Result<YelpResult, Error>) -> ()) {
      let url = "https://api.yelp.com/v3/businesses/search?attributes=hot_and_new&latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)"
        performRequest(with: url, completion: completion)
  }
}
