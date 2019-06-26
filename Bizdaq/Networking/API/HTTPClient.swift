//
//  HTTPClient.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

final class HTTPClient: HTTPProtocol {
    
    // MARK: - Properties
    static let shared = HTTPClient()
    var baseURL = Constants.Networking.serverBaseUrl
    
    enum HTTPClientError: Error {
        case invalidURL
        case notConnected
        case decodeFailed
        case unknown
    }
    
    // MARK: - Singleton Lifecycle
    private init() { }
    
    // MARK: - Public Methods
    func setBaseURL(_ url: String) {
        baseURL = url
    }
    
    func post<T>(endpoint: String, params: Parameters?, headers: HTTPHeaders) -> Single<T> where T: Decodable {

        return request(endpoint: endpoint, params: params, headers: headers, method: .post)
    }
    
    func get<T>(endpoint: String, params: Parameters? = nil, headers: HTTPHeaders) -> Single<T> where T: Decodable {
        return request(endpoint: endpoint, params: params, headers: headers, method: .get)
    }
    
    // MARK: - Private Methods
    enum Result<T: Decodable> {
        case success(value: T)
        case error(error: Error)
    }
    
    func request<T>(endpoint: String, params: Parameters?, headers: HTTPHeaders, method: HTTPMethod) -> Single<T> where T: Decodable {
        if !Constants.Networking.silentish {
            debugPrint(params ?? "no params")
        }
        let observable = PublishSubject<T>()
        Alamofire.request(baseURL + endpoint, method: method, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { [weak self] (response) in
            if !Constants.Networking.silentish {
                print(response)
            }
            guard let `self` = self else { observable.onError(HTTPClientError.unknown); return }
            switch self.handle(response, responseType: T.self) {
            case .success(let value):
                self.printSuccess(endPoint: endpoint)
                observable.onNext(value)
                observable.onCompleted()
            case .error(let error):
                debugPrint(error)
                self.printError(endPoint: endpoint)
                observable.onError(error)
            }
        }
        return observable.asSingle()
    }
    
    private func handle<T: Decodable>(_ response: DataResponse<Any>, responseType: T.Type) -> Result<T> {
        if !Constants.Networking.silentish {
            debugPrint(response.result)
        }
        switch response.result {
        case .success(_):
            let jsonDecoder = JSONDecoder()
            do {
                let response = try jsonDecoder.decode(T.self, from: response.data!)
                return Result.success(value: response)
            } catch let error {
                debugPrint(error)
                return Result.error(error: HTTPClientError.decodeFailed)
            }
        case .failure(let error):
            if let `error` = error as? URLError, error.code == .notConnectedToInternet {
                return Result.error(error: HTTPClientError.notConnected)
            } else {
                return Result.error(error: HTTPClientError.unknown)
            }
        }
    }
    
    func upload<T>(endpoint: String, params: [String: String]?, images: [String: UIImage]?, headers: HTTPHeaders, method: HTTPMethod) -> Single<T> where T: Decodable {
        if !Constants.Networking.silentish {
            debugPrint(params ?? "no params")
        }
        let observable = PublishSubject<T>()
        Alamofire.upload(
            multipartFormData: { (formData) in
            params?.forEach({ (key, value) in
                if let data = value.data(using: .utf8) {
                    formData.append(data, withName: key)
                }
            })
            images?.forEach({ (key, value) in
                if let data = UIImagePNGRepresentation(value) {
                    formData.append(data, withName: key, fileName: key, mimeType: "image/png")
                }
            })
        },
            usingThreshold: UInt64.init(),
            to: baseURL + endpoint,
            method: .post,
            headers: headers) { (response) in
                switch response {
                case .success(let request, _, _):
                    request.responseData(completionHandler: { [weak self] (data) in
                        guard let `self` = self else { return }
                        switch self.handle(data, responseType: T.self) {
                        case .success(let value):
                            self.printSuccess(endPoint: endpoint)
                            observable.onNext(value)
                            observable.onCompleted()
                        case .error(let error):
                            self.printError(endPoint: endpoint)
                            observable.onError(error)
                        }
                    })
                case .failure(_):
                    observable.onError(HTTPClientError.unknown)
                }
        }
        return observable.asSingle()
    }
    
    func upload<T>(endpoint: String, params: [String: String]?, documents: [String: URL]?, headers: HTTPHeaders, method: HTTPMethod) -> Single<T> where T: Decodable {
        if !Constants.Networking.silentish {
            debugPrint(params ?? "no params")
        }
        let observable = PublishSubject<T>()
        Alamofire.upload(
            multipartFormData: { (formData) in
                params?.forEach({ (key, value) in
                    if let data = value.data(using: .utf8) {
                        formData.append(data, withName: key)
                    }
                })
                documents?.forEach({ (key, value) in
                    var mimeType = ""
                    let filename = value.lastPathComponent
                    if filename.hasSuffix(".docx"){
                        mimeType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                    }
                    if filename.hasSuffix(".doc"){
                        mimeType = "application/msword"
                    }
                    if filename.hasSuffix(".pdf"){
                        mimeType = "application/pdf"
                    }
                    if filename.hasSuffix(".rtf"){
                        mimeType = "application/rtf"
                    }
                    if filename.hasSuffix(".xls"){
                        mimeType = "application/vnd.ms-excel"
                    }
                    if filename.hasSuffix(".xlsx"){
                        mimeType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                    }
                    if filename.hasSuffix(".txt"){
                        mimeType = "text/plain"
                    }
                    if filename.hasSuffix(".jpeg"){
                        mimeType = "image/jpeg"
                    }
                    do {
                        let data = try Data(contentsOf: value.standardizedFileURL)
                        formData.append(data, withName: key, fileName: filename, mimeType: mimeType)
                    } catch {
                        debugPrint("CAn't convert to data.")// catch errors here
                    }                   
                })
        },
            //usingThreshold: UInt64.init(),
            to: baseURL + endpoint,
            method: .post,
            headers: headers) { (response) in
                if !Constants.Networking.silentish {
                    debugPrint(headers)
                    debugPrint(response)
                }
                switch response {
                case .success(let request, _, _):


                    request.responseData(completionHandler: { [weak self] (data) in
                        if !Constants.Networking.silentish {
                            debugPrint("data")
                            debugPrint(data)
                        }

                        guard let `self` = self else { return }
                        switch self.handle(data, responseType: T.self) {
                        case .success(let value):
                            self.printSuccess(endPoint: endpoint)
                            observable.onNext(value)
                            observable.onCompleted()
                        case .error(let error):
                            self.printError(endPoint: endpoint)
                            observable.onError(error)
                        }
                    })
                case .failure(_):
                    observable.onError(HTTPClientError.unknown)
                }
        }
        return observable.asSingle()
    }
    
    
    private func handle<T: Decodable>(_ response: DataResponse<Data>, responseType: T.Type) -> Result<T> {
        if !Constants.Networking.silentish {

        }
        switch response.result {
        case .success(_):
            let jsonDecoder = JSONDecoder()
            do {
                let jsonDecodedResponse = try jsonDecoder.decode(T.self, from: response.data!)
                if !Constants.Networking.silentish {
                    debugPrint(jsonDecodedResponse)
                }
                return Result.success(value: jsonDecodedResponse)
            } catch { return Result.error(error: HTTPClientError.decodeFailed) }
        case .failure(let error):
            debugPrint(error)
            if let `error` = error as? URLError, error.code == .notConnectedToInternet {
                return Result.error(error: HTTPClientError.notConnected)
            } else {
                return Result.error(error: HTTPClientError.unknown)
            }
        }
    }
    
    private func printSuccess(endPoint: String) {
        debugPrint("🌐 NETWORK REQUEST -> 😃 SUCCESS")
        debugPrint("\(endPoint)")
    }
    
    private func printError(endPoint: String) {
        debugPrint("🌐 NETWORK REQUEST -> 😭 ERROR")
        debugPrint("\(endPoint)")
    }
}
