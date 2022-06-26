//
//  Weather.swift
//  Weather
//
//  Created by Pierre Chevallier on 25/05/2022.
//  Copyright © 2022 Pierre Chevallier. All rights reserved.
//

import Foundation

public class Weather: Decodable {
    var elevation: Float!
    var generationtime_ms: Float!
    var utc_offset_seconds: Int!
    var hourly: Hourly!
    var hourly_units: HourlyUnits!
    var current_weather: CurrentWeather!
    
    public class Hourly: Decodable {
        var time: [String]!
        var temperature_2m: [Float]!
        var weathercode: [Int]!
    }
    
    public class HourlyUnits: Decodable {
        var temperature_2m: String!
    }
    
    public class CurrentWeather: Decodable {
        var time: String!
        var temperature: Float!
        var weathercode: Int!
        var windspeed: Float!
        var winddirection: Int!
    }
}
