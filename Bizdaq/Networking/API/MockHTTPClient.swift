//
//  MockHTTPClient.swift
//  BizdaqTests
//
//  Created by Joseph Lunn on 13/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class MockHTTPClient: HTTPProtocol {
    func upload<T>(endpoint: String, params: [String : String]?, documents: [String : URL]?, headers: HTTPHeaders, method: HTTPMethod) -> PrimitiveSequence<SingleTrait, T> where T : Decodable {

            let subject: ReplaySubject<T> = ReplaySubject.create(bufferSize: 1)
            switch resultFromFixture(fixture: fixture, responseType: T.self) {
            case .success(let value):
                subject.onNext(value)
            case .error(let error):
                subject.onError(error)
            }
            subject.onCompleted()
            return subject.asSingle()
    }
    
    
    // MARK: - Properties
    var fixture: String
    
    // MARK: - Lifecycle
    init(fixture: String) {
        self.fixture = fixture
    }
    
    // MARK: - Public Methods
    func post<T>(endpoint: String, params: Parameters?, headers: HTTPHeaders) -> Single<T> where T : Decodable {
        return request(endpoint: endpoint, params: params, headers: headers)
    }
    
    func get<T>(endpoint: String, params: Parameters?, headers: HTTPHeaders) -> Single<T> where T : Decodable {
        return request(endpoint: endpoint, params: params, headers: headers)
    }
    
    // MARK: - Private Methods
    enum MockHTTPClientError: Error {
        case decodeFailed
        case unknownFixture
    }
    
    enum Result<T: Decodable> {
        case success(value: T)
        case error(error: Error)
    }
    
    private func resultFromFixture<T>(fixture resource: String, responseType: T.Type) -> Result<T> where T : Decodable {
        if let path = Bundle(for: MockHTTPClient.self).path(forResource: resource, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(T.self, from: data)
                return Result.success(value: response)
            } catch {
                return Result.error(error: MockHTTPClientError.decodeFailed)
            }
        }
        return Result.error(error: MockHTTPClientError.unknownFixture)
    }
    
    private func request<T>(endpoint: String, params: Parameters?, headers: HTTPHeaders) -> Single<T> where T : Decodable {
        let subject: ReplaySubject<T> = ReplaySubject.create(bufferSize: 1)
        switch resultFromFixture(fixture: fixture, responseType: T.self) {
        case .success(let value):
            subject.onNext(value)
        case .error(let error):
            subject.onError(error)
        }
        subject.onCompleted()
        return subject.asSingle()
    }
    
    func upload<T>(endpoint: String, params: [String : String]?, images: [String : UIImage]?, headers: HTTPHeaders, method: HTTPMethod) -> PrimitiveSequence<SingleTrait, T> where T : Decodable {
        let subject: ReplaySubject<T> = ReplaySubject.create(bufferSize: 1)
        switch resultFromFixture(fixture: fixture, responseType: T.self) {
        case .success(let value):
            subject.onNext(value)
        case .error(let error):
            subject.onError(error)
        }
        subject.onCompleted()
        return subject.asSingle()
    }
    
    func upload<T>(image: UIImage?, withName: String, endpoint: String, headers: HTTPHeaders) -> PrimitiveSequence<SingleTrait, T> where T : Decodable {
        let subject: ReplaySubject<T> = ReplaySubject.create(bufferSize: 1)
        switch resultFromFixture(fixture: fixture, responseType: T.self) {
        case .success(let value):
            subject.onNext(value)
        case .error(let error):
            subject.onError(error)
        }
        subject.onCompleted()
        return subject.asSingle()
    }
}
