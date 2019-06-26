//
//  APIEndpoints+Valuation.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/11/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

extension Endpoint {
    static func startValuation(authToken: AuthToken?,
                               businessSectorId: String,
                               tenure: String,
                               annualTurnover: String,
                               businessPostcode: String,
                               userName: String?,
                               emailAddress: String,
                               phoneNumber: String) -> Endpoint {
        let queryItems = [
            URLQueryItem(name: "auth_token", value: authToken),
            URLQueryItem(name: "business_sector_id", value: businessSectorId),
            URLQueryItem(name: "tenure", value: tenure),
            URLQueryItem(name: "annual_turnover", value: annualTurnover),
            URLQueryItem(name: "business_postcode", value: businessPostcode),
            URLQueryItem(name: "anonymous_user_name", value: userName),
            URLQueryItem(name: "anonymous_user_email_address", value: emailAddress),
            URLQueryItem(name: "anonymous_phone_number", value: phoneNumber)
        ]
        return Endpoint(path: "/app-api/valuation", queryItems: queryItems)
    }
    
    static func completeValuation(authToken: AuthToken?,
                                  businessSectorId: String,
                                  tenure: String,
                                  annualTurnover: String,
                                  businessPostcode: String,
                                  userName: String?,
                                  emailAddress: String,
                                  phoneNumber: String,
                                  metricData: [String: String]) -> Endpoint {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "auth_token", value: authToken),
            URLQueryItem(name: "business_sector_id", value: businessSectorId),
            URLQueryItem(name: "tenure", value: tenure),
            URLQueryItem(name: "annual_turnover", value: annualTurnover),
            URLQueryItem(name: "business_postcode", value: businessPostcode),
            URLQueryItem(name: "anonymous_user_name", value: userName),
            URLQueryItem(name: "anonymous_user_email_address", value: emailAddress),
            URLQueryItem(name: "anonymous_phone_number", value: phoneNumber)
        ]
        metricData.forEach { (name, value) in
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        return Endpoint(path: "/app-api/valuation", queryItems: queryItems)
    }
}
