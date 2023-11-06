//
//  MockTrackService.swift
//  ItuneSearchDemoTests
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation
@testable import ItuneSearchDemo

class MockTrackService: TrackServiceProtocol {
    var didFetchTrack: Bool = false
    var mockFetchTrackResult: Result<[Track], APIError>?
    
    var didFetchCountry: Country?
    var didFetchMediaType: MediaType?
    
    func fetchTrack(
        for term: String,
        offset: Int,
        limit: Int,
        country: Country,
        mediaType: MediaType,
        completion: @escaping (Result<[Track], APIError>) -> Void
    ) {
        didFetchTrack = true
        didFetchCountry = country
        didFetchMediaType = mediaType
        
        if let mockFetchTrackResult = mockFetchTrackResult {
            completion(mockFetchTrackResult)
        }
    }
}
