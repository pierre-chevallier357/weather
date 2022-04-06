//
//  CityWithLocation.swift
//  Demo
//
//  Created by Pierre Chevallier on 04/04/2022.
//  Copyright © 2022 Julie Saby. All rights reserved.
//

import Foundation

class CityWithLocationAPI {
    private let session: URLSession
    
    private func baseUrl() -> String {
        return "https://api.bigdatacloud.net/data/reverse-geocode-client?"
    }
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getBaseRequest(latitude: String, longitude: String) -> String {
        let url = URL(string: baseUrl() + "latitude=" + latitude + "&longitude=" + longitude + "&localityLanguage=fr")!
        _ = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
              if let error = error {
                print("Error with fetching films: \(error)")
                return
              }
              
              guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        print("Error with the response, unexpected status code: \(String(describing: response) )")
                return
              }
            })
            task.resume()
        return data
    }
}
