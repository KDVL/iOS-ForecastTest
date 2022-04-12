//
//  ForecastItemDTO.swift
//  App
//
//

import Foundation

struct ForecastItemDTO: Codable {
    let day: String
    let description: String
    let sunrise, sunset: Int
    let chanceRain: Double
    let high, low: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case day
        case description
        case sunrise, sunset
        case chanceRain = "chance_rain"
        case high, low, type
    }
}
