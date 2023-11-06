//
//  MockStorageService.swift
//  ItuneSearchDemoTests
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation
@testable import ItuneSearchDemo

class MockStorageService: StorageServiceProtocol {
    var mockFavouriteTrack: [Track] = []
    
    func addFavouriteTrack(track: Track) {
        mockFavouriteTrack.append(track)
    }
    
    func removeFavouriteTrack(track: Track) {
        mockFavouriteTrack.removeAll { existingTrack in
            existingTrack.trackId == track.trackId
        }
    }
    
    func getAllFavouriteTracks() -> [Track] {
        return mockFavouriteTrack
    }
}
