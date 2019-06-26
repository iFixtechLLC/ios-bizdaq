//
//  AdditionalValuationViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

class AdditionalValuationViewModel: CanRequestValuations {
    
    // MARK: - Properties
    var apiClient: APIClient
    var authToken: AuthToken?
    private let valuationProperties: ValuationViewModel.InitialValuationProperties
    private let widgets: Widgets
    private let isFreehold: Bool
    var bag = DisposeBag()
    
    struct Key {
        static let basicBusinessValuationPropertyFreehold = "basic_business_valuation_property_freehold"
        static let metricDataNetProfit = "metric_data_net_profit"
        static let metricDataAdjustments = "metric_data_adjustments"
        static let metricDataAdjustmentsAssetValue = "metric_data_asset_value"
        static let metricDataWeeklyTakings = "metric_data_weekly_takings"
        static let metricDataProperty = "metric_data_property"
        static let metricDataTenantIncomePa = "metric_data_tenant_income_pa"
        static let metricDataOriginalFranchiseFee = "metric_data_original_franchise_fee"
        static let metricDataWetLed = "metric_data_wet_led"
        static let metricDataDryLed = "metric_data_dry_led"
        static let metricDataPostOfficeSalary = "metric_data_post_office_salary"
    }
    
    var keys: [String]
    var titles: [String : String]
    var values = [String : String]()
    
    // Table View
    var amountOfRows: Int { return titles.count }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient,
         authToken: AuthToken?,
         valuationProperties: ValuationViewModel.InitialValuationProperties,
         widgets: Widgets,
         isFreehold: Bool) {
        self.apiClient = apiClient
        self.authToken = authToken
        self.valuationProperties = valuationProperties
        self.widgets = widgets
        self.isFreehold = isFreehold
        self.keys = Array(widgets.titles().keys)
        self.titles = widgets.titles()
    }
    
    // MARK: - Public Methods
    func title(for key: String) -> String? {
        return titles[key]
    }
    
    func setValue(_ value: String, for key: String) {
        debugPrint(value)
        debugPrint(key)
        guard keys.contains(key) else { debugPrint("Not in keys"); return }
        values[key] = value
    }
    
    func completeValuation(completion: @escaping (_ valuation: CreateBusinessValuationResponse?) -> Void) {
        guard valuationProperties.modelComplete() else { completion(nil); return }
        Array(values.keys).forEach { (key) in
            if !keys.contains(key) { return }
            
        }
        if(values.count != widgets.titles().count){
            
            debugPrint(values)
            debugPrint("widgets")
            debugPrint(widgets)
            
            return
        }

        let authToken = UserSession.shared.authToken

        apiClient.submitValuation(authToken: authToken ?? "",
                                  businessSectorId: valuationProperties.sectorId!,
                                  tenure: valuationProperties.tenure!,
                                  annualTurnover: valuationProperties.annualTurnover!,
                                  businessPostcode: valuationProperties.postcode,
                                  userName: valuationProperties.userName,
                                  emailAddress: valuationProperties.emailAddress,
                                  phoneNumber: valuationProperties.phoneNumber, widgetValues: values)
            .subscribe(onSuccess: { (response) in
                //                completion()
                debugPrint("SUCCESS!")
                debugPrint(response)
                completion(response)
            }, onError: { (error) in
                debugPrint(error)
            })
            .disposed(by: bag)
    }
}
