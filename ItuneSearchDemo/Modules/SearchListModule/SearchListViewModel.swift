//
//  SearchListViewModel.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import Foundation

protocol SearchListViewModelInputType {
    // TODO: tap or view event
    var onViewDidLoad: Observable<Void> { get }
}

protocol SearchListViewModelOutputType {
    var isLoading: Observable<Bool> { get }
    var tracks: Observable<[Track]> { get }
    var error: Observable<APIError?> { get }
}


protocol SearchListViewModelProtocol {
    var input: SearchListViewModelInputType { get }
    var output: SearchListViewModelOutputType { get }
}

final class SearchListViewModel: SearchListViewModelProtocol, SearchListViewModelInputType, SearchListViewModelOutputType {
    // MARK: - input
    var input: SearchListViewModelInputType { return self }
    var onViewDidLoad: Observable<Void> = .init(())
    
    // MARK: - output
    var output: SearchListViewModelOutputType { return self }
    var isLoading: Observable<Bool> = .init(false)
    var tracks: Observable<[Track]> = .init([])
    var error: Observable<APIError?> = .init(nil)
    
    // MARK: - Dependencies
    private let trackService: TrackServiceProtocol
    
    init(trackService: TrackServiceProtocol) {
        self.trackService = trackService
        
        setupBinding()
    }
    
    private func setupBinding() {
        onViewDidLoad.bind { [weak self] in
            guard let self = self else { return }
            self.trackService.fetchTrack(completion: { result in
                switch result {
                case .success(let tracks):
                    self.tracks.value = tracks
                case .failure(let error):
                    self.error.value = error
                }
            })
        }
    }
}
