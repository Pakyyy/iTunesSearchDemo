//
//  Track.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import Foundation

struct Track: Codable {
    let trackId: Int?
    let name: String?
    let artistName: String?
    let albumName: String?
    let albumArtworkUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case trackId = "trackId"
        case name = "trackName"
        case artistName = "artistName"
        case albumName = "collectionName"
        // Take one of the artwork from the response as our artwork
        case albumArtworkUrl = "artworkUrl60"
    }
}
