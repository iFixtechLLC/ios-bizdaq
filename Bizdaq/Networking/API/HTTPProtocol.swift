//
//  HTTPProtocol.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol HTTPProtocol {
    
    func post<T>(endpoint: String, params: Parameters?, headers: HTTPHeaders) -> Single<T> where T : Decodable
    func get<T>(endpoint: String, params: Parameters?, headers: HTTPHeaders) -> Single<T> where T : Decodable
    func upload<T>(endpoint: String, params: [String: String]?, images: [String: UIImage]?, headers: HTTPHeaders, method: HTTPMethod) -> Single<T> where T: Decodable
    func upload<T>(endpoint: String, params: [String: String]?, documents: [String: URL]?, headers: HTTPHeaders, method: HTTPMethod) -> Single<T> where T: Decodable
}
