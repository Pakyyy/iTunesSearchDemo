//
//  APIError.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import Foundation

enum APIError: Error {
    case invalidRequest
    case invalidResponse
    case networkError(String)
}

extension APIError: Equatable {
    static func ==(lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRequest, .invalidRequest): return true
        case (.invalidResponse, .invalidResponse): return true
        case (.networkError, .networkError): return true
        default:
            return false
        }
    }
}
