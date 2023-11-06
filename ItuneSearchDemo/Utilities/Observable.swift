//
//  Observable.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import Foundation

// Simple class to stimulate RxSwift reactive functionality
class Observable<T> {
    typealias Listener = (T) -> ()
    
    private var debounceTimer: Timer?
    
    var listener: Listener?
    var value: T {
        didSet {
            self.fire()
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    func fire() {
        self.listener?(value)
    }
    
    // Simple debounce method
    // There are plenty of way to debounce our call, here we pick the simplest one to keep thing simple
    func debounce(with timeInterval: TimeInterval, _ value: T) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] _ in
            self?.value = value
        })
    }
}
