//
//  TrackResponse.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import Foundation

struct TrackResponse: Decodable {
    let resultCount: Int
    let results: [Track]
}
