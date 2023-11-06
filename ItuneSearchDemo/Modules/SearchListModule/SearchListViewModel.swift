//
//  SearchListViewModel.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import Foundation

protocol SearchListViewModelInputType {
    var onViewDidLoad: Observable<Void> { get }
    var onSearchTextDidChange: Observable<String> { get }
    var onSearchBarCancelButtonClicked: Observable<Void> { get }
    var onPageReachedEnd: Observable<Void> { get }
    var onCountryButtonClicked: Observable<Void> { get }
    var onMediaTypeButtonClicked: Observable<Void> { get }
    var onSelectedCountry: Observable<Country> { get }
    var onSelectedMediaType: Observable<MediaType> { get }
    var onSelectedRow: Observable<Int> { get }
    var onSelectedLanguage: Observable<Language> { get }
}

protocol SearchListViewModelOutputType {
    var isLoading: Observable<Bool> { get }
    var tracks: Observable<[Track]> { get }
    var error: Observable<APIError?> { get }
    var filterNavigationEvent: Observable<FilterNavigationType?> { get }
    var currentLanguage: Observable<Language> { get }
}

protocol SearchListViewModelProtocol {
    var input: SearchListViewModelInputType { get }
    var output: SearchListViewModelOutputType { get }
}

enum FilterNavigationType {
    case country(Country)
    case mediaType(MediaType)
}

final class SearchListViewModel: SearchListViewModelProtocol, SearchListViewModelInputType, SearchListViewModelOutputType {
    // MARK: private constants
    private struct Constants {
        static let defaultPageOffset: Int = 20
        static let debounceSecond: TimeInterval = 1.0
    }
    
    // MARK: - input
    var input: SearchListViewModelInputType { return self }
    var onViewDidLoad: Observable<Void> = .init(())
    var onSearchTextDidChange: Observable<String> = .init("")
    var onSearchBarCancelButtonClicked: Observable<Void> = .init(())
    var onPageReachedEnd: Observable<Void> = .init(())
    var onCountryButtonClicked: Observable<Void> = .init(())
    var onMediaTypeButtonClicked: Observable<Void> = .init(())
    var onSelectedCountry: Observable<Country> = .init(.UnitedStatesOfAmerica)
    var onSelectedMediaType: Observable<MediaType> = .init(.all)
    var onSelectedRow: Observable<Int> = .init(0)
    var onSelectedLanguage: Observable<Language> = .init(.english)
    
    // MARK: - output
    var output: SearchListViewModelOutputType { return self }
    var isLoading: Observable<Bool> = .init(false)
    var tracks: Observable<[Track]> = .init([])
    var error: Observable<APIError?> = .init(nil)
    var filterNavigationEvent: Observable<FilterNavigationType?> = .init(nil)
    var currentLanguage: Observable<Language>
    
    // MARK: - Dependencies
    private let trackService: TrackServiceProtocol
    private let storageService: StorageServiceProtocol
    private let languageManager: LanguageManager = LanguageManager.shared
    
    // MARK: - private variable
    private let queryString: Observable<String> = .init("")
    private let currentPage: Observable<Int> = .init(0)
    private let selectedCountry: Observable<Country> = .init(.UnitedStatesOfAmerica)
    private let selectedMediaType: Observable<MediaType> = .init(.all)

    init(
        trackService: TrackServiceProtocol,
        storageService: StorageServiceProtocol
    ) {
        self.trackService = trackService
        self.storageService = storageService
        
        currentLanguage = .init(languageManager.currentLanguage)
        setupBinding()
        setupNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupBinding() {
        onViewDidLoad.bind { [weak self] in
            guard let self = self else { return }
            self.fetchTrack()
        }
        
        onSearchTextDidChange.bind { [weak self] searchText in
            self?.queryString.debounce(with: 1.0, searchText)
        }
        
        onSearchBarCancelButtonClicked.bind { [weak self] in
            self?.queryString.debounce(with: 1.0, "")
        }
        
        onPageReachedEnd.bind { [weak self] in
            guard let self = self else { return }
            // Ensure it is not loading when we debounce another current page value
            guard self.isLoading.value == false else { return }
            // Debounce the page reached end event
            self.currentPage.debounce(with: 0.5, self.currentPage.value + 1)
        }
        
        onCountryButtonClicked.bind { [weak self] in
            guard let self = self else { return }
            
            self.filterNavigationEvent.value = .country(self.selectedCountry.value)
        }
        
        onMediaTypeButtonClicked.bind { [weak self] in
            guard let self = self else { return }
            
            self.filterNavigationEvent.value = .mediaType(self.selectedMediaType.value)
        }
        
        onSelectedCountry.bind { [weak self] newSelectedCountry in
            guard let self = self else { return }
            
            self.selectedCountry.value = newSelectedCountry
        }
        
        onSelectedMediaType.bind { [weak self] newSelectedMediaType in
            guard let self = self else { return }
            
            self.selectedMediaType.value = newSelectedMediaType
        }
        
        onSelectedRow.bind { [weak self] index in
            guard let self = self else { return }
            
            self.storageService.addFavouriteTrack(track: self.tracks.value[index])
        }
        
        onSelectedLanguage.bind { [weak self] language in
            self?.languageManager.currentLanguage = language
        }
        
        // Binding for private variable
        queryString.bind { [weak self] queryString in
            guard let self = self else { return }
            
            if queryString.isEmpty == true {
                self.currentPage.value = 0
            }
            
            self.fetchTrack()
        }
        
        currentPage.bind { [weak self] _ in
            guard let self = self else { return }
            // Only fetch track if there is a queryString
            guard self.queryString.value.isEmpty == false else { return }
            
            self.fetchTrack(isRefresh: false)
        }
        
        selectedCountry.bind { [weak self] _ in
            // Fetch tracks whenever selected country is updated
            self?.fetchTrack()
        }
        
        selectedMediaType.bind { [weak self] _ in
            // Fetch tracks whenever media type is updated
            self?.fetchTrack()
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChanged), name: LanguageManager.languageDidChanged, object: nil)
    }
    
    @objc private func languageDidChanged() {
        currentLanguage.value = languageManager.currentLanguage
    }
    
    private func fetchTrack(isRefresh: Bool = true) {
        guard self.isLoading.value == false else { return }
        // Clear all search result when queryString is empty
        guard queryString.value.isEmpty == false else {
            tracks.value = []
            return
        }
        
        isLoading.value = true
        trackService.fetchTrack(
            for: queryString.value,
            offset: Constants.defaultPageOffset * currentPage.value,
            limit: Constants.defaultPageOffset,
            country: selectedCountry.value,
            mediaType: selectedMediaType.value,
            completion: { result in
                self.isLoading.value = false
                switch result {
                case .success(let tracks):
                    self.tracks.value = isRefresh == true ? tracks : self.tracks.value + tracks
                case .failure(let error):
                self.error.value = error
                }
            }
        )
    }
}
