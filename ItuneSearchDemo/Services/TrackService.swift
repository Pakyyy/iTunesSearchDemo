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
    func fetchTrack(completion: @escaping (Result<[Track], APIError>) -> Void)
}

final class TrackService: TrackServiceProtocol {
    // MARK: - Dependencies
    private let session: NetworkServiceProtocol
    
    init(session: NetworkServiceProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchTrack(completion: @escaping (Result<[Track], APIError>) -> Void) {
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/search"
        
        components.queryItems = [
            URLQueryItem(name: "term", value: "jack johnson"),
            URLQueryItem(name: "offset", value: "5"),
            URLQueryItem(name: "limit", value: "5")
        ]
        
        guard let url = components.url else {
            completion(.failure(.invalidRequest))
            return
        }
        
        print(url)
        
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
