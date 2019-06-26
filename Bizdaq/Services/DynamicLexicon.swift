//
//  DynamicLexicon.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 25/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

final class DynamicLexicon {
    
    // MARK: - Properties
    static fileprivate var shared = DynamicLexicon()

    
    private let bag = DisposeBag()
    fileprivate let apiClient: APIClient
    
    // (K)ey (V)alue (P)airs
    typealias KVP = [String: String]
    var howDidYouHearAboutUs: KVP?
    var businessTenure: KVP?
    var businessPropertyHasAccomodation: KVP?
    var businessHasStaff: KVP?
    var businessCurrentStatus: KVP?
    var timescale: KVP?
    var type: KVP?
    var year: KVP?
    var tenure: KVP?
    static func getKeyByValue(array:KVP?, value:String?) -> String {
        guard array != nil else { return "" }
        guard value != nil else { return "" }

        
        var answer = value!
        array!.forEach { (k, v) in
            if value == v {
                answer = k
            }
        }
        return answer
    }
    // Business data
    var businessSectors: [BusinessSector]?
    var businessCategories: [BusinessCategory]?
    var businessLocations: [BusinessLocation]?
    var businessRegions: [BusinessRegion]?
    
    // Public interface
    enum PreDefinedChoices {
        enum PublicUser {
            static var howDidYouHearAboutUs: KVP? { return DynamicLexicon.shared.howDidYouHearAboutUs }
        }
        enum Business {
            static var tenure: KVP? { return DynamicLexicon.shared.businessTenure }
            static var propertyHasAccomodation: KVP? { return DynamicLexicon.shared.businessPropertyHasAccomodation }
            static var hasStaff: KVP? { return DynamicLexicon.shared.businessHasStaff }
            static var currentStatus: KVP? { return DynamicLexicon.shared.businessCurrentStatus }
        }
        enum BusinessEngagementBid {
            static var timescale: KVP? { return DynamicLexicon.shared.timescale }
        }
        enum BusinessDocument {
            static var type: KVP? { return DynamicLexicon.shared.type }
        }
        enum BasicBusinessValuation {
            static var tenure: KVP? { return DynamicLexicon.shared.tenure }
        }
    }
    
    enum Business {
        static var sectors: [BusinessSector]? { return DynamicLexicon.shared.businessSectors }
        static var categories: [BusinessCategory]? { return DynamicLexicon.shared.businessCategories }
        static var locations: [BusinessLocation]? { return DynamicLexicon.shared.businessLocations }
        static var regions: [BusinessRegion]? { return DynamicLexicon.shared.businessRegions }
    }
    
    // MARK: - Singleton Lifecycle
    private init() {
        self.apiClient = APIClient(httpClient: HTTPClient.shared)
    }
    
    // MARK: - Public Methods
    static func update(success: @escaping (_ success: Bool) -> Void) {
        let lexicon = DynamicLexicon.shared
        
        let listPreDefinedChoices = lexicon.apiClient.listPreDefinedChoices()
        let listBusinessSectors = lexicon.apiClient.listBusinessSectors()
        let listBusinessCategories = lexicon.apiClient.listBusinessCategories()
        let listBusinessLocations = lexicon.apiClient.listBusinessLocations()
        let listBusinessRegions = lexicon.apiClient.listBusinessRegions()
        
        Single.zip(listPreDefinedChoices,
                   listBusinessSectors,
                   listBusinessCategories,
                   listBusinessLocations,
                   listBusinessRegions)
            .subscribe(onSuccess: { (preDefinedChoices, sectors, categories, locations, regions) in
                // Parse pre-defined choices
                lexicon.howDidYouHearAboutUs = preDefinedChoices.data.publicUserChoices.howDidYouHearAboutUs
                lexicon.businessTenure = preDefinedChoices.data.businessChoices.tenure
                lexicon.businessPropertyHasAccomodation = preDefinedChoices.data.businessChoices.propertyHasAccomodation
                lexicon.businessHasStaff = preDefinedChoices.data.businessChoices.hasStaff
                lexicon.businessCurrentStatus = preDefinedChoices.data.businessChoices.currentStatus
                lexicon.timescale = preDefinedChoices.data.businessEngagementChoices.timescale
                lexicon.type = preDefinedChoices.data.businessDocumentChoices.type
                lexicon.year = preDefinedChoices.data.businessDocumentChoices.year
                lexicon.tenure = preDefinedChoices.data.basicBusinessValuationChoices.tenure
                
                // Parse business options
                lexicon.businessSectors = sectors.data
                lexicon.businessCategories = categories.data
                lexicon.businessLocations = locations.data
                lexicon.businessRegions = regions.data
                
                success(true)
            }) { (error) in
                success(false)
            }
            .disposed(by: lexicon.bag)
    }
}
