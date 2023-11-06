//
//  LanguageManager.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation

// Simple singleton class for localization
class LanguageManager {
    static let shared: LanguageManager = LanguageManager()
    static let languageDidChanged: Notification.Name = Notification.Name("languageDidChanged")
    private let languageKey: String = "LanguageKey"
    
    private init() {}
    
    var currentLanguage: Language {
        get {
            guard let languageString = UserDefaults.standard.string(forKey: languageKey) else {
                return .english
            }
            return Language(rawValue: languageString) ?? .english
        } set {
            if newValue != currentLanguage {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: languageKey)
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: LanguageManager.languageDidChanged, object: nil)
            }
        }
    }
}
