//
//  TrackService.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import Foundation

// Both NetworkServiceProtocol & URLSessionDataTaskProtocol are mockable protocol to replace and inject a mock class for unit test
protocol NetworkServiceProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol TrackServiceProtocol {
    func fetchTrack(
        for term: String,
        offset: Int,
        limit: Int,
        country: Country,
        mediaType: MediaType,
        completion: @escaping (Result<[Track], APIError>) -> Void
    )
}

final class TrackService: TrackServiceProtocol {
    // MARK: - Dependencies
    private let session: NetworkServiceProtocol
    private let config: ConfigProtocol
    
    init(
        session: NetworkServiceProtocol = URLSession.shared,
        config: ConfigProtocol = Config()
    ) {
        self.session = session
        self.config = config
    }
    
    func fetchTrack(
        for term: String,
        offset: Int,
        limit: Int,
        country: Country,
        mediaType: MediaType,
        completion: @escaping (Result<[Track], APIError>) -> Void
    ) {
        var components: URLComponents = URLComponents()
        components.scheme = config.defaultScheme
        components.host = config.baseUrl
        components.path = config.searchPath
        
        components.queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "country", value: country.queryString),
            URLQueryItem(name: "media", value: mediaType.queryString)
        ]
        
        if term.isEmpty == false {
            components.queryItems?.append(URLQueryItem(name: "term", value: term))
        }
        
        guard let url = components.url else {
            completion(.failure(.invalidRequest))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            } else {
                guard let jsonData = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                let decoder = JSONDecoder()
                guard let responseData = try? decoder.decode(TrackResponse.self, from: jsonData) else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                completion(.success(responseData.results))
            }
        }.resume()
    }
}
