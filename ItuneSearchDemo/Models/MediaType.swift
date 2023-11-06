//
//  MediaType.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation

enum MediaType: String, CaseIterable {
    case movie = "Movie"
    case podcast = "Podcast"
    case music = "Music"
    case musicVideo = "Music Video"
    case audiobook = "Audio Book"
    case shortFilm = "ShortFilm"
    case tvShow = "TV Show"
    case software = "Software"
    case ebook = "EBook"
    case all = "All"
    
    var queryString: String {
        switch self {
        case .movie: return "movie"
        case .podcast: return "podcast"
        case .music: return "music"
        case .musicVideo: return "musicVideo"
        case .audiobook: return "audiobook"
        case .shortFilm: return "shortFilm"
        case .tvShow: return "tvShow"
        case .software: return "software"
        case .ebook: return "ebook"
        case .all: return "all"
        }
    }
}
