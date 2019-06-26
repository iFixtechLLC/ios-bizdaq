//
//  Constants.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 06/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

typealias AuthToken = String

enum Constants {
    static let bizdaqNavLogoImageName = "navigation-bizdaq-icon"
    static let placeholderImageName = "placeholder"
    
    enum Networking {
        static let bizdaqKey = "biz_ZQ083LskJ5vBiI2HlWgH4olfL2"
        static let stagingServerBaseURL = "http://staged.mybizdaq.com/app-api"
        static let liveServerBaseURL = "https://www.mybizdaq.com/app-api"
        
        static let networkScheme = "https"
        static let networkHost = "www.mybizdaq.com"
        static let development = true
        static let serverBaseUrl = development ? stagingServerBaseURL : liveServerBaseURL
        static let imageServerURL = development ?  "http://staged.mybizdaq.com" :  "https://www.mybizdaq.com"
        static let silentish = true

    }
    
    enum Validation {
        static let anyCharactersRegex = ".*"
        static let integerRegex = "[0-9]{1,19}"
        static let doubleRegex = "[0-9]{1-17}(\\.[0-9]{1-2})?"
        static let firstNameRegex = "[A-Za-z]{2,24}"
        static let lastNameRegex = "[A-Za-z]{2,24}"
        static let mobileRegex = "[0-9]{10,20}"
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        static let hearAboutusRegex = "[A-Za-z]{2,24}"
        static let businessSectorsRegex = "[A-Za-z]{2,24}"
        static let postcodeRegex = "^(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y]))) {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2}))$"
        static let yearRegex = "^\\d{4}$"
    }
}
