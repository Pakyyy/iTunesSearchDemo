//
//  UITableViewCell+Extensions.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import UIKit

extension UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
}
