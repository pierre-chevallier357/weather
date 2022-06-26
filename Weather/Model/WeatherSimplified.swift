//
//  WeatherSimplified.swift
//  Demo
//
//  Created by Pierre Chevallier on 24/06/2022.
//  Copyright © 2022 Julie Saby. All rights reserved.
//

import Foundation

public class WeatherSimplified: Decodable {
    var weatherCode: Int!
    var time: String!
    var temperature: Float!
}
