//
//  String+Extensions.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation

extension String {
    func localized() -> String {
        // Get current language from LanguageManager
        let currentLanguage: Language = LanguageManager.shared.currentLanguage

        let path = Bundle.main.path(forResource: currentLanguage.rawKey, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        
        // To keep thing simple, use the string as the translation key
        // Fallback value as the translation key
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
    }
}
