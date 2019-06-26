//
//  APIEndpoints.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/11/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.Networking.networkScheme
        components.host = Constants.Networking.networkHost
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
