//
//  TrackServiceTests.swift
//  ItuneSearchDemoTests
//
//  Created by Patrick Tang on 6/11/2023.
//

import XCTest
@testable import ItuneSearchDemo

struct TestConfig: ConfigProtocol {
    let defaultScheme: String = "https"
    let baseUrl: String = "itunes.apple.com"
    var searchPath: String = "/search"
}

final class TrackServiceTests: XCTestCase {
    // MARK: - System under test
    private var sut: TrackServiceProtocol!
    
    // MARK: - Dependencies
    private var session: MockNetworkService!
    private var config: TestConfig!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        session = MockNetworkService()
        config = TestConfig()
        sut = TrackService(session: session, config: config)
    }

    override func tearDownWithError() throws {
        session = nil
        config = nil
        sut = nil
        
        try super.tearDownWithError()
    }

    func testFetchTrackInvalidRequestError() {
        // Setup another sut with different copnfig to cover the invalidRequest caes
        config.searchPath = "invalidPathWhichWillReturnAnNilURL"
        sut = TrackService(session: session, config: config)
        
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.fetchTrack(for: "DUMMY_TERM", offset: 10, limit: 10, country: .UnitedStatesOfAmerica, mediaType: .all) { result in
            switch result {
            case .success(_):
                XCTFail("\(#function) is expected to return error")
            case .failure(let error):
                // Expected to return an invalidRequest error, when config provide an incorrect path
                XCTAssertEqual(error, .invalidRequest)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTrackNetworkError() {
        session.mockData = nil
        session.mockURLResponse = nil
        session.mockError = APIError.networkError("DUMMY_NETWORK_ERROR")
        
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.fetchTrack(for: "DUMMY_TERM", offset: 10, limit: 10, country: .UnitedStatesOfAmerica, mediaType: .all) { result in
            switch result {
            case .success:
                XCTFail("\(#function) is expected to return error")
            case .failure(let error):
                XCTAssertEqual(error, .networkError("DIFFERENT_DUMMY_NETWORK_ERROR"))
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTrackWithNoResponseData() {
        session.mockData = nil
        session.mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://randomDummyUrl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        session.mockError = nil
        
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.fetchTrack(for: "DUMMY_TERM", offset: 10, limit: 10, country: .UnitedStatesOfAmerica, mediaType: .all) { result in
            switch result {
            case .success:
                XCTFail("\(#function) is expected to return error")
            case .failure(let error):
                XCTAssertEqual(error, .invalidResponse)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTrackInvalidResponseStatusCode() {
        let mockResponseData: Data = getData(name: "FetchTrackSuccessPayload")
        session.mockData = mockResponseData
        session.mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://randomDummyUrl.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!
        session.mockError = nil
        
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.fetchTrack(for: "DUMMY_TERM", offset: 10, limit: 10, country: .UnitedStatesOfAmerica, mediaType: .all) { result in
            switch result {
            case .success:
                XCTFail("\(#function) is expected to return error")
            case .failure(let error):
                XCTAssertEqual(error, .invalidResponse)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTrackInvalidResponse() {
        let mockResponseData: Data = getData(name: "FetchTrackInvalidPayload")
        session.mockData = mockResponseData
        session.mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://randomDummyUrl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        session.mockError = nil
        
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.fetchTrack(for: "DUMMY_TERM", offset: 10, limit: 10, country: .UnitedStatesOfAmerica, mediaType: .all) { result in
            switch result {
            case .success:
                XCTFail("\(#function) is expected to return error")
            case .failure(let error):
                XCTAssertEqual(error, .invalidResponse)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTrackSuccess() {
        let mockResponseData: Data = getData(name: "FetchTrackSuccessPayload")
        session.mockData = mockResponseData
        session.mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://randomDummyUrl.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        session.mockError = nil
        
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.fetchTrack(for: "DUMMY_TERM", offset: 10, limit: 10, country: .UnitedStatesOfAmerica, mediaType: .all) { result in
            switch result {
            case .success(let tracks):
                XCTAssertEqual(tracks.count, 5)
            case .failure:
                XCTFail("\(#function) is expected to success")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Test helper
extension TrackServiceTests {
    func getData(name: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: name, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
}
