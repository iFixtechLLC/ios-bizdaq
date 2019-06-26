//
//  Widget.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

struct Widgets: Codable {
    
    // MARK: - Properties
    let basicBusinessValuationPropertyFreehold: String?
    let metricDataNetProfit: String?
    let metricDataAdjustments: String?
    let metricDataAdjustmentsAssetValue: String?
    let metricDataWeeklyTakings: String?
    let metricDataProperty: String?
    let metricDataTenantIncomePa: String?
    let metricDataOriginalFranchiseFee: String?
    let metricDataWetLed: String?
    let metricDataDryLed: String?
    let metricDataPostOfficeSalary: String?
    
    enum CodingKeys: String, CodingKey {
        case basicBusinessValuationPropertyFreehold = "basic_business_valuation_property_freehold"
        case metricDataNetProfit = "metric_data_net_profit"
        case metricDataAdjustments = "metric_data_adjustments"
        case metricDataAdjustmentsAssetValue = "metric_data_asset_value"
        case metricDataWeeklyTakings = "metric_data_weekly_takings"
        case metricDataProperty = "metric_data_property"
        case metricDataTenantIncomePa = "metric_data_tenant_income_pa"
        case metricDataOriginalFranchiseFee = "metric_data_original_franchise_fee"
        case metricDataWetLed = "metric_data_wet_led"
        case metricDataDryLed = "metric_data_dry_led"
        case metricDataPostOfficeSalary = "metric_data_post_office_salary"
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        basicBusinessValuationPropertyFreehold = try values.decodeIfPresent(String.self, forKey: .basicBusinessValuationPropertyFreehold)
        metricDataNetProfit = try values.decodeIfPresent(String.self, forKey: .metricDataNetProfit)
        metricDataAdjustments = try values.decodeIfPresent(String.self, forKey: .metricDataAdjustments)
        metricDataAdjustmentsAssetValue = try values.decodeIfPresent(String.self, forKey: .metricDataAdjustmentsAssetValue)
        metricDataWeeklyTakings = try values.decodeIfPresent(String.self, forKey: .metricDataWeeklyTakings)
        metricDataProperty = try values.decodeIfPresent(String.self, forKey: .metricDataProperty)
        metricDataTenantIncomePa = try values.decodeIfPresent(String.self, forKey: .metricDataTenantIncomePa)
        metricDataOriginalFranchiseFee = try values.decodeIfPresent(String.self, forKey: .metricDataOriginalFranchiseFee)
        metricDataWetLed = try values.decodeIfPresent(String.self, forKey: .metricDataWetLed)
        metricDataDryLed = try values.decodeIfPresent(String.self, forKey: .metricDataDryLed)
        metricDataPostOfficeSalary = try values.decodeIfPresent(String.self, forKey: .metricDataPostOfficeSalary)
    }
    
    // MARK: - Public Methods
    func titles() -> [String : String] {
        var titles = [String: String]()
        if basicBusinessValuationPropertyFreehold != nil { titles[CodingKeys.basicBusinessValuationPropertyFreehold.rawValue] = basicBusinessValuationPropertyFreehold! }
        if metricDataNetProfit != nil { titles[CodingKeys.metricDataNetProfit.rawValue] = metricDataNetProfit }
        if metricDataAdjustments != nil { titles[CodingKeys.metricDataAdjustments.rawValue] = metricDataAdjustments }
        if metricDataAdjustmentsAssetValue != nil { titles[CodingKeys.metricDataAdjustmentsAssetValue.rawValue] = metricDataAdjustmentsAssetValue }
        if metricDataWeeklyTakings != nil { titles[CodingKeys.metricDataWeeklyTakings.rawValue] = metricDataWeeklyTakings }
        if metricDataProperty != nil { titles[CodingKeys.metricDataProperty.rawValue] = metricDataProperty }
        if metricDataTenantIncomePa != nil { titles[CodingKeys.metricDataTenantIncomePa.rawValue] = metricDataTenantIncomePa }
        if metricDataOriginalFranchiseFee != nil { titles[CodingKeys.metricDataOriginalFranchiseFee.rawValue] = metricDataOriginalFranchiseFee }
        if metricDataWetLed != nil { titles[CodingKeys.metricDataWetLed.rawValue] = metricDataWetLed }
        if metricDataDryLed != nil { titles[CodingKeys.metricDataDryLed.rawValue] = metricDataDryLed }
        if metricDataPostOfficeSalary != nil { titles[CodingKeys.metricDataPostOfficeSalary.rawValue] = metricDataPostOfficeSalary }
        debugPrint(titles)
        return titles
    }
}
