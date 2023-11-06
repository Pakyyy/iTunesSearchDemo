//
//  Language.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 6/11/2023.
//

import Foundation

enum Language: String, CaseIterable {
    case english = "English"
    case traditionalChinese = "繁體中文"
    case simplifiedChinese = "简体中文"
    
    var rawKey: String {
        switch self {
        case .english: return "en"
        case .traditionalChinese: return "zh-Hant"
        case .simplifiedChinese: return "zh-Hans"
        }
    }
}
