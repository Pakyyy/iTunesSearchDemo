//
//  FavouriteListViewModel.swift
//  ItuneSearchDemoTests
//
//  Created by Patrick Tang on 6/11/2023.
//

import XCTest
@testable import ItuneSearchDemo

final class FavouriteListViewModel: XCTestCase {
    // MARK: - System under test
    private var sut: FavouriteListViewModelProtocol!
    
    // MARK: - Dependencies
    private var storageService: MockStorageService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        storageService = MockStorageService()
        sut = FavouriteViewModel(storageService: storageService)
    }

    override func tearDownWithError() throws {
        storageService = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testOnViewDidAppear() {
        storageService.mockFavouriteTrack = [
            Track(trackId: 99, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil),
            Track(trackId: 88, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil)
        ]
        
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.tracks.bind { tracks in
            // Expected to return the favourite tracks from storage
            XCTAssertEqual(tracks.count, 2)
            expectation.fulfill()
        }
        
        sut.input.onViewDidAppear.value = ()
        wait(for: [expectation], timeout: 3.0)
    }

    func testOnSelectedRow() throws {
        sut.output.tracks.value = [
            Track(trackId: 99, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil),
            Track(trackId: 88, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil)
        ]
        storageService.mockFavouriteTrack = [
            Track(trackId: 99, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil),
            Track(trackId: 88, name: nil, artistName: nil, albumName: nil, albumArtworkUrl: nil)
        ]
        let expectation: XCTestExpectation = XCTestExpectation(description: #function)
        sut.output.tracks.bind { tracks in
            // Expected to return the favourite tracks from storage
            XCTAssertEqual(tracks.count, 1)
            expectation.fulfill()
        }
        
        sut.input.onSelectedRow.value = 0
        wait(for: [expectation], timeout: 3.0)
        // Expected the first item is removed
        let track: Track = try XCTUnwrap(sut.output.tracks.value.first)
        XCTAssertEqual(track.trackId, 88)
    }
}
