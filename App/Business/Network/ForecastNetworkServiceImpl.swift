//
//  ForecastNetworkServiceImpl.swift
//  App
//
//

import Foundation
import Combine

class ForecastNetworkServiceImpl: ForecastNetworkService {
    func getForecast() -> AnyPublisher<[ForecastItemDTO], Error> {
        let url = URL(string: "https://62540f2319bc53e23478024c.mockapi.io/api/forecast")!
        return URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: [ForecastItemDTO].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
