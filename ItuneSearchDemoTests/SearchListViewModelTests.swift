//
//  SearchListViewModelTests.swift
//  ItuneSearchDemoTests
//
//  Created by Patrick Tang on 6/11/2023.
//

import XCTest
@testable import ItuneSearchDemo

final class SearchListViewModelTests: XCTestCase {
    // MARK: - System under test
    private var sut: SearchListViewModelProtocol!
    
    // MARK: - Dependencies
    private var trackService: MockTrackService!
    private var storageService: MockStorageService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        trackService = MockTrackService()
        storageService = MockStorageService()
        
        sut = SearchListViewModel(
            trackService: trackService,
            storageService: storageService
        )
    }

    override func tearDownWithError() throws {
        trackService = nil
        storageService = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testOnViewDidLoadWithError() {
        // Wait for the debounce set up
        trackService.mockFetchTrackResult = .success([
            Track(trackId: 99, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil)])
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.tracks.bind { tracks in
            expectation.fulfill()
        }
        sut.input.onSearchTextDidChange.value = "DEMO_SEARCH_TEXT"
        wait(for: [expectation], timeout: 2.0)
        
        let errorExpectation: XCTestExpectation = XCTestExpectation(description: #function)
        trackService.mockFetchTrackResult = .failure(.invalidResponse)
        sut.output.error.bind { _ in
            errorExpectation.fulfill()
        }
        sut.input.onViewDidLoad.value = ()
        wait(for: [errorExpectation], timeout: 3.0)
    }
    
    func testOnViewDidLoadWithEmptyQueryString() {
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        
        sut.output.tracks.bind { tracks in
            // Expected to fetch tracks and return empty array as query string is empty when viewDidLoad
            XCTAssert(tracks.isEmpty == true)
            expectation.fulfill()
        }
        
        sut.input.onViewDidLoad.value = ()
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testOnSearchTextDidChange() {
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        trackService.mockFetchTrackResult = .success([
            Track(trackId: 99, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil),
            Track(trackId: 88, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil)
        ])
        
        sut.output.tracks.bind { tracks in
            // Excpected to fetch tracks according to serch text
            XCTAssertEqual(tracks.count, 2)
            expectation.fulfill()
        }
        
        sut.input.onSearchTextDidChange.value = "DEMO_SEARCH_TEXT"
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testOnSearchBarCancelButtonClicked() {
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        
        sut.output.tracks.bind { tracks in
            // Expected to fetch tracks and return empty array as query string is empty
            XCTAssert(tracks.isEmpty == true)
            expectation.fulfill()
        }
        
        sut.input.onSearchBarCancelButtonClicked.value = ()
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testOnPageReachedEndWhenLoading() {
        sut.output.isLoading.value = true
        sut.input.onPageReachedEnd.value = ()
        XCTAssertFalse(self.trackService.didFetchTrack)
    }
    
    func testOnPageReachedEndWhenQueryStringIsEmpty() {
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Expected currentPage will be updated after 1.0 second debounce
            expectation.fulfill()
        }
        
        sut.input.onPageReachedEnd.value = ()
        wait(for: [expectation], timeout: 3.0)
        // Expected not to call fetch track when queryString is empty
        XCTAssertFalse(trackService.didFetchTrack)
    }
    
    func testOnPageReachEnd() {
        trackService.mockFetchTrackResult = .success([
            Track(trackId: 99, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil)])
        
        // Wait for the debounce set up
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.tracks.bind { tracks in
            expectation.fulfill()
        }
        sut.input.onSearchTextDidChange.value = "DEMO_SEARCH_TEXT"
        wait(for: [expectation], timeout: 2.0)
        
        // Reset didFetchTrack
        trackService.didFetchTrack = false
        let pageReachedExpectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.tracks.bind { tracks in
            pageReachedExpectation.fulfill()
        }
        sut.input.onPageReachedEnd.value = ()
        // Expected to fetch tracks when page reached end
        wait(for: [pageReachedExpectation], timeout: 3.0)
        XCTAssert(trackService.didFetchTrack == true)
    }
    
    func testOnCountryButtonClicked() {
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.filterNavigationEvent.bind { event in
            switch event {
            case .country(let country):
                XCTAssertEqual(country, .UnitedStatesOfAmerica)
                expectation.fulfill()
            case .mediaType:
                XCTFail("Expected to return the selected country")
            case .none:
                XCTFail("Expected to return the selected country")
            }
        }
        
        sut.input.onCountryButtonClicked.value = ()
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testOnMediaTypeButtonClicked() {
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.filterNavigationEvent.bind { event in
            switch event {
            case .country:
                XCTFail("Expected to return current media type")
            case .mediaType(let mediaType):
                XCTAssertEqual(mediaType, .all)
                expectation.fulfill()
            case .none:
                XCTFail("Expected to return current media type")
            }
        }
        
        sut.input.onMediaTypeButtonClicked.value = ()
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testOnSelectedCountry() throws {
        trackService.mockFetchTrackResult = .success([
            Track(trackId: 99, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil)])
        // Wait for the debounce set up
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.tracks.bind { tracks in
            expectation.fulfill()
        }
        sut.input.onSearchTextDidChange.value = "DEMO_SEARCH_TEXT"
        wait(for: [expectation], timeout: 2.0)
        
        let selectCountryExpectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.tracks.bind { _ in
            selectCountryExpectation.fulfill()
        }
        
        sut.input.onSelectedCountry.value = .Afghanistan
        wait(for: [selectCountryExpectation], timeout: 3.0)
        let resultFetchCountry: Country = try XCTUnwrap(trackService.didFetchCountry)
        XCTAssertEqual(resultFetchCountry, .Afghanistan)
    }
    
    func testOnSelectedMediaType() throws {
        trackService.mockFetchTrackResult = .success([
            Track(trackId: 99, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil)])
        // Wait for the debounce set up
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.tracks.bind { tracks in
            expectation.fulfill()
        }
        sut.input.onSearchTextDidChange.value = "DEMO_SEARCH_TEXT"
        wait(for: [expectation], timeout: 2.0)
        
        let selectMediaTypeExpectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.tracks.bind { _ in
            selectMediaTypeExpectation.fulfill()
        }
        
        sut.input.onSelectedMediaType.value = .audiobook
        wait(for: [selectMediaTypeExpectation], timeout: 3.0)
        
        let resultFetchMediaType: MediaType = try XCTUnwrap(trackService.didFetchMediaType)
        XCTAssertEqual(resultFetchMediaType, .audiobook)
    }
    
    func testOnSelectedRow() {
        sut.output.tracks.value = [
            Track(trackId: 99, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil)]
        
        sut.input.onSelectedRow.value = 0
        // Expected to add the selected track to storage
        XCTAssert(storageService.mockFavouriteTrack.count == 1)
    }
}
