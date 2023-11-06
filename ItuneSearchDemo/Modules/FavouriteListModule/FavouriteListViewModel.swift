//
//  FavouriteListViewModel.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation

protocol FavouriteListViewModelInputType {
    var onViewDidAppear: Observable<Void> { get }
    var onSelectedRow: Observable<Int> { get }
}

protocol FavouriteListViewModelOutputType {
    var tracks: Observable<[Track]> { get }
    var currentLanguage: Observable<Language> { get }
}

protocol FavouriteListViewModelProtocol {
    var input: FavouriteListViewModelInputType { get }
    var output: FavouriteListViewModelOutputType { get }
}

final class FavouriteViewModel: FavouriteListViewModelProtocol, FavouriteListViewModelInputType, FavouriteListViewModelOutputType {
    // MARK: - input
    var input: FavouriteListViewModelInputType { return self }
    var onViewDidAppear: Observable<Void> = .init(())
    var onSelectedRow: Observable<Int> = .init(0)
    
    // MARK: - output
    var output: FavouriteListViewModelOutputType { return self }
    var tracks: Observable<[Track]> = .init([])
    var currentLanguage: Observable<Language>
    
    // MARK: - Dependencies
    private let storageService: StorageServiceProtocol
    private let languageManager: LanguageManager = LanguageManager.shared
    
    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
        
        currentLanguage = .init(languageManager.currentLanguage)
        setupBinding()
        setupNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChanged), name: LanguageManager.languageDidChanged, object: nil)
    }
    
    @objc private func languageDidChanged() {
        currentLanguage.value = languageManager.currentLanguage
    }
    
    private func setupBinding() {
        onViewDidAppear.bind { [weak self] in
            guard let self = self else { return }
            self.tracks.value = self.storageService.getAllFavouriteTracks()
        }
        
        onSelectedRow.bind { [weak self] index in
            guard let self = self else { return }
            
            guard index < self.tracks.value.count else { return }
            
            self.storageService.removeFavouriteTrack(track: self.tracks.value[index])
            self.tracks.value = self.storageService.getAllFavouriteTracks()
        }
    }
}
