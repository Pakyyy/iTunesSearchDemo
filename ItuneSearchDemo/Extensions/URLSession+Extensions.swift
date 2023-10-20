//
//  URLSession+Extensions.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import Foundation

extension URLSession: NetworkServiceProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}
