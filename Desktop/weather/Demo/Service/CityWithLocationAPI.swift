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
    
    func getCity(latitude: String, longitude: String, completion: @escaping (Weather?) -> Void) {
        let url = URL(string: baseUrl() + "latitude=" + latitude + "&longitude=" + longitude + "&localityLanguage=fr")!
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let dataResult = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let stationsResult = try jsonDecoder.decode(Weather.self, from: dataResult)
                        completion(stationsResult)
                    }
                    catch {
                        print("Error")
                    }
                }
                else {
                    print("No result")
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        session.resume()
    }
}
