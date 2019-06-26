//
//  AdvertParameters.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct AdvertParameters {
    
    // MARK: - Properties
    var businessSectorId: Int?
    var tenure: String?
    var propertyRentPerAnnum: Int?
    var propertyFreeholdValue: Int?
    var propertyHasAccommodaton: String?
    var postcode: String?
    var isBusinessLocationConfidential: Int?
    var annualTurnover: Int?
    var netProfit: Int?
    var hasStaff: String?
    var yearBusinessEstablished: Int?
    var askingPrice: Int?
    var isOpenToOffers: Bool = true
    var isStockAtValueAdded: Bool?
    var advertHeadline: String?
    var opportunity: String?
    var property: String?
    var situation: String?
    var isBusinessPhotoConfidential: Bool?
    
    var businessId: Int?
    
    // MARK: - Lifecycle
    init() {
        
    }
    
    init(from business: Business) {
        debugPrint(business)
        businessId = business.id
        businessSectorId = business.businessSector?.id
        tenure = business.tenure
        propertyRentPerAnnum = business.propertyRentPerAnnum
        propertyFreeholdValue = business.propertyFeeholdValue
        propertyHasAccommodaton = DynamicLexicon.getKeyByValue(array: DynamicLexicon.PreDefinedChoices.Business.propertyHasAccomodation, value: business.propertyHasAccomodation)

        postcode = business.address?.postcode
        annualTurnover = business.annualTurnover
        netProfit = business.netProfit
        hasStaff = DynamicLexicon.getKeyByValue(array: DynamicLexicon.PreDefinedChoices.Business.hasStaff, value: business.hasStaff)
 
        yearBusinessEstablished = business.yearBusinessEstablished
        askingPrice = business.askingPrice
        opportunity = business.opportunity
        propertyRentPerAnnum = business.propertyRentPerAnnum
        propertyFreeholdValue = business.propertyFeeholdValue
        advertHeadline = business.advertHeadline
        situation = business.situation
    }
    
}
