//
//  ForecastNetworkService.swift
//  App
//
//

import Combine

protocol ForecastNetworkService {
    func getForecast() -> AnyPublisher<[ForecastItemDTO], Error>
}
