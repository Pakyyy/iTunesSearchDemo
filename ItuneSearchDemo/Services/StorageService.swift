//
//  StorageService.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation

protocol StorageServiceProtocol {
    func addFavouriteTrack(track: Track)
    func removeFavouriteTrack(track: Track)
    func getAllFavouriteTracks() -> [Track]
}

// For demo, we will use UserDefault to store the data locally
// With StorageServiceProtocol, we can replace the service easily if the data go larger and more complex
// Note: As StorageService do not contain any logic now, it is not covered in the demo's unit test
class StorageService: StorageServiceProtocol {
    private struct StorageKey {
        static let favouriteTracksKey: String = "favouriteTracksKey"
    }
    
    private var tempStoredTrack: [Track] {
        get {
            let storedData: Data? = standardStorage.data(forKey: StorageKey.favouriteTracksKey)
            guard let storedData = storedData else { return [] }

            let decoder: JSONDecoder = JSONDecoder()
            let tracks: [Track]? = try? decoder.decode([Track].self, from: storedData)
            
            guard let tracks = tracks else { return [] }
            return tracks
        }
        set {
            let encoder: JSONEncoder = JSONEncoder()
            let jsonData = try? encoder.encode(newValue)
            standardStorage.set(jsonData, forKey: StorageKey.favouriteTracksKey)
        }
    }
    
    private let standardStorage: UserDefaults
    init(storage: UserDefaults = .standard) {
        self.standardStorage = storage
    }
    
    func addFavouriteTrack(track: Track) {
        tempStoredTrack.append(track)
    }
    
    func removeFavouriteTrack(track: Track) {
        tempStoredTrack.removeAll { existingTrack in
            existingTrack.trackId == track.trackId
        }
    }
    
    func getAllFavouriteTracks() -> [Track] {
        return tempStoredTrack
    }
}
