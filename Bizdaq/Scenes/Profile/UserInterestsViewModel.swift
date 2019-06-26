//
//  UserInterestsViewModel.swift
//  Bizdaq
//
//  Created by App Dev on 05/03/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//
import Foundation

class UserInterestsViewModel {
    
    
    
    
    // MARK: - Properties
    var interests = [InterestTypes]()
    var selectionHandler: ((_ interest_types: [InterestTypes]) -> Void)?
    var selectedInterest: InterestTypes?
    
    // MARK: - Lifecycle
    init(selectionHandler: @escaping (_ interest_types: [InterestTypes]) -> Void) {
        self.selectionHandler = selectionHandler
        if let userInterests = UserSession.shared.user?.publicUser.publicUserBuyerProfile?.publicUserInterestTypes {
            debugPrint("got interests")
            self.interests = userInterests.map {
                try! InterestTypes.init(sector_id: $0.businessSectorId, region_id: $0.businessRegionId)
            }
        }
        debugPrint(interests)
    }
    
    // MARK: - Public Methods
    func setInterest(index: Int) {
        guard index < interests.count && index >= 0 else { return }
        selectedInterest = interests[index]
    }
    func addInterest(interest: InterestTypes){
        if(interest.businessRegionId != nil && interest.businessSectorId != nil ){
            interests.append(interest)
        }
    }
    func removeInterest(index: Int){
        guard index < interests.count && index >= 0 else { return }
        interests.remove(at: index)
    }
    func removeInterest(interest: InterestTypes){
        interests.removeAll(where: { $0.id == interest.id })
    }
    
    func save(){
        self.selectionHandler!(interests)
    }
}
