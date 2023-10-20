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
    
    internal func fire() {
        self.listener?(value)
    }
}
