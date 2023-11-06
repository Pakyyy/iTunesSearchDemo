//
//  Config.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation

protocol ConfigProtocol {
    var defaultScheme: String { get }
    var baseUrl: String { get }
    var searchPath: String { get }
}

struct Config: ConfigProtocol {
    let defaultScheme: String = "https"
    let baseUrl: String = "itunes.apple.com"
    let searchPath: String = "/search"
}
