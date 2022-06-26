//
//  Weather.swift
//  Weather
//
//  Created by Pierre Chevallier on 04/05/2022.
//  Copyright © 2022 Pierre Chevallier. All rights reserved.
//

import Foundation

public class City: Decodable {
    var latitude: Float!
    var longitude: Float!
    var locality: String!
    var city: String!
    
    /*
    var elevation: Float!
    var generationtime_ms: Float!
    var utc_offset_seconds: Int!
    var hourly: Hourly!
    var hourly_units: HourlyUnits!
    var current_weather: CurrentWeather!
    
    public class Hourly: Decodable {
        var time: [Date]!
        var temperature_2m: [Int]!
    }
    
    public class HourlyUnits: Decodable {
        var temperature_2m: String!
    }
    
    public class CurrentWeather: Decodable {
        var time: Date!
        var temperature: Float!
        var weathercode: Int!
        var windspeed: Float!
        var winddirection: Int!
    }
     */
}
