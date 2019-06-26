//
//  NetworkResponse.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 15/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(_ response: T)
    case error(_ error: HTTPClient.HTTPClientError)
}
