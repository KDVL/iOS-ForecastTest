//
//  ForecastNetworkServiceImpl.swift
//  App
//
//

import Foundation
import Combine

class ForecastNetworkServiceImpl: ForecastNetworkService {
    func getForecast() -> AnyPublisher<[ForecastItemDTO], Error> {
        let url = URL(string: "https://gist.githubusercontent.com/KDVL/e7f029dacebeefb2b7ce8ffdfe2d2315/raw/e013e1dc3fa649c003810ffa3acd7f57c405b217/forecast.json")!
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
