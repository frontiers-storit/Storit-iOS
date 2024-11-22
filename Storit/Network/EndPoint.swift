//
//  EndPoint.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/6/24.
//

import Foundation
import Alamofire

protocol EndPoint {
    var baseURL: String { get }
    var url: URL { get }
    var path: String { get }
    var query: [String: String] { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var task: APITask { get }
}

extension EndPoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.baseURL
        components.path = self.path
        components.queryItems = self.query.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    var query: [String: String] {
        return [:]
    }
}
