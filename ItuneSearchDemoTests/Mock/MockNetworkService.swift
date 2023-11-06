//
//  MockNetworkService.swift
//  ItuneSearchDemoTests
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation
@testable import ItuneSearchDemo

final class MockNetworkService: NetworkServiceProtocol {
    var mockDataTask: MockURLSessionDataTask = MockURLSessionDataTask()
    
    var mockData: Data?
    var mockURLResponse: URLResponse?
    var mockError: Error?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(mockData, mockURLResponse, mockError)
        return mockDataTask
    }
}
