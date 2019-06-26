//
//  Business.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct Business: Codable {

    // MARK: - Properties
    let id: Int?
    let sellerPublicUserId: Int?
    let name: String?
    let advertHeadline: String?
    let tenure: String?
    let address: BusinessAddress?
    let businessSector: BusinessSector?
    let businessLocation: BusinessLocation?
    var yearBusinessEstablished: Int?
    let numberOfYearsEstablished: Int?
    let propertyFeeholdValue: Int?
    let propertyRentPerAnnum: Int?
    let propertyHasAccomodation: String?
    let hasStaff: String?
    let annualTurnover: Int?
    let grossProfit: Int?
    let netProfit: Int?
    let adjustedNetProfit: Int?
    let opportunity: String?
    let askingPrice: Int?
    let currentStatus: String?
    let businessPhotos: [BusinessPhoto]?
    let enquiryCount: Int?
    let viewsCount: Int?
    let viewingCount: Int?
    let offerCount: Int?
    let isFreeTrial: Bool?
    let isActive: Bool?
    let isPremiumListing: Bool?
    let isCancelled: Bool?
    let dateTimeCancelled: String?
    var isSaved: Bool?
    let zooplaAdvertLink: String?
    let daltonsAdvertLink: String?
    let situation: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case sellerPublicUserId = "seller_public_user_id"
        case advertHeadline = "advert_headline"
        case name = "name"
        case tenure = "tenure"
        case address = "Address"
        case businessSector = "BusinessSector"
        case businessLocation = "BusinessLocation"
        case yearBusinessEstablished = "year_business_established"
        case numberOfYearsEstablished = "number_of_years_established"
        case propertyFeeholdValue = "property_feehold_value"
        case propertyRentPerAnnum = "property_rent_per_annum"
        case propertyHasAccomodation = "property_has_accomodation"
        case hasStaff = "has_staff"
        case annualTurnover = "annual_turnover"
        case grossProfit = "gross_profit"
        case netProfit = "net_profit"
        case adjustedNetProfit = "adjusted_net_profit"
        case opportunity = "opportunity"
        case askingPrice = "asking_price"
        case currentStatus = "current_status"
        case businessPhotos = "BusinessPhotos"
        case enquiryCount = "enquiry_count"
        case viewsCount = "views_count"
        case viewingCount = "viewing_count"
        case offerCount = "offer_count"
        case isFreeTrial = "is_free_trial"
        case isActive = "is_active"
        case isPremiumListing = "is_premium_listing"
        case isCancelled = "is_cancelled"
        case dateTimeCancelled = "date_time_cancelled"
        case isSaved = "is_saved"
        case zooplaAdvertLink = "zooplaAdvertLink"
        case daltonsAdvertLink = "daltonsAdvertLink"
        case situation = "situation"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        sellerPublicUserId = try values.decodeIfPresent(Int.self, forKey: .sellerPublicUserId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        advertHeadline = try values.decodeIfPresent(String.self, forKey: .advertHeadline)
        tenure = try values.decodeIfPresent(String.self, forKey: .tenure)
        address = try values.decodeIfPresent(BusinessAddress.self, forKey: .address)
        businessSector = try values.decodeIfPresent(BusinessSector.self, forKey: .businessSector)
        businessLocation = try values.decodeIfPresent(BusinessLocation.self, forKey: .businessLocation)
        ///yearBusinessEstablished = try values.decodeIfPresent(Int.self, forKey: .yearBusinessEstablished)
        if let value = try? values.decodeIfPresent(Int.self, forKey: .yearBusinessEstablished) {
            yearBusinessEstablished = value
        } else {
            yearBusinessEstablished = Int(try values.decodeIfPresent(String.self, forKey: .yearBusinessEstablished) ?? "2019")
        }
        
        numberOfYearsEstablished = try values.decodeIfPresent(Int.self, forKey: .numberOfYearsEstablished)
        propertyFeeholdValue = try values.decodeIfPresent(Int.self, forKey: .propertyFeeholdValue)
        propertyRentPerAnnum = try values.decodeIfPresent(Int.self, forKey: .propertyRentPerAnnum)
        propertyHasAccomodation = try values.decodeIfPresent(String.self, forKey: .propertyHasAccomodation)
        hasStaff = try values.decodeIfPresent(String.self, forKey: .hasStaff)
        annualTurnover = try values.decodeIfPresent(Int.self, forKey: .annualTurnover)
        grossProfit = try values.decodeIfPresent(Int.self, forKey: .grossProfit)
        netProfit = try values.decodeIfPresent(Int.self, forKey: .netProfit)
        adjustedNetProfit = try values.decodeIfPresent(Int.self, forKey: .adjustedNetProfit)
        opportunity = try values.decodeIfPresent(String.self, forKey: .opportunity)
        askingPrice = try values.decodeIfPresent(Int.self, forKey: .askingPrice)
        currentStatus = try values.decodeIfPresent(String.self, forKey: .currentStatus)
        businessPhotos = try values.decodeIfPresent([BusinessPhoto].self, forKey: .businessPhotos)
        enquiryCount = try values.decodeIfPresent(Int.self, forKey: .enquiryCount)
        viewsCount = try values.decodeIfPresent(Int.self, forKey: .viewsCount)
        viewingCount = try values.decodeIfPresent(Int.self, forKey: .viewingCount)
        offerCount = try values.decodeIfPresent(Int.self, forKey: .offerCount)
        isFreeTrial = try values.decodeIfPresent(Bool.self, forKey: .isFreeTrial)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        isPremiumListing = try values.decodeIfPresent(Bool.self, forKey: .isPremiumListing)
        isCancelled = try values.decodeIfPresent(Bool.self, forKey: .isCancelled)
        dateTimeCancelled = try values.decodeIfPresent(String.self, forKey: .dateTimeCancelled)
        isSaved = try values.decodeIfPresent(Bool.self, forKey: .isSaved)
        zooplaAdvertLink = try values.decodeIfPresent(String.self, forKey: .zooplaAdvertLink)
        daltonsAdvertLink = try values.decodeIfPresent(String.self, forKey: .daltonsAdvertLink)
        situation = try values.decodeIfPresent(String.self, forKey: .situation)
    }
}
