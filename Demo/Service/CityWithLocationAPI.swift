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
    
    private func baseCityUrl() -> String {
        return "https://api.bigdatacloud.net/data/reverse-geocode-client?"
    }
    
    private func baseWeatherUrl() -> String {
        return "https://api.open-meteo.com/v1/forecast?"
    }
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getCity(latitude: String, longitude: String, completion: @escaping (City?) -> Void) {
        let url = URL(string: baseCityUrl() + "latitude=" + latitude + "&longitude=" + longitude + "&localityLanguage=fr")!
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let dataResult = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let stationsResult = try jsonDecoder.decode(City.self, from: dataResult)
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
    
    func getWeather(latitude: String, longitude: String, completion: @escaping (Weather?) -> Void) {
        let url = URL(string: baseWeatherUrl() + "latitude=" + latitude + "&longitude=" + longitude + "&hourly=temperature_2m")!
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
