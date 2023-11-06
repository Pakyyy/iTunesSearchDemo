//
//  MockURLSessionDataTask.swift
//  ItuneSearchDemoTests
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation
@testable import ItuneSearchDemo

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
