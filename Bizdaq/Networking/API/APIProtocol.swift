//
//  APIProtocol.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol APIProtocol {
    
    // MARK: - Register/Login
    typealias RegisterBuyerResponse = UserResponse
    func registerBuyer(firstName: String,
                       lastName: String,
                       mobilePhone: String,
                       emailAddress: String,
                       password: String,
                       howDidYouHearAboutUs: String?,
                       businessSectorsOfInterest: [String]?) -> Single<RegisterBuyerResponse>
    
    func registerSeller(firstName: String,
                        lastName: String,
                        mobilePhone: String,
                        emailAddress: String,
                        password: String) -> Single<RegisterSellerResponse>
    
    typealias LoginResponse = UserResponse
    func login(emailAddress: String, password: String) -> Single<LoginResponse>
    
    func recoverPassword(emailAddress: String) -> Single<BasicResponse>

    
    // MARK: - Businesses
    func listBusinesses(authToken: AuthToken?,
                        sellerPublicUserId: String?,
                        sectorId: String?,
                        categoryId: String?,
                        locationId: String?,
                        tenure: String?,
                        askingPriceMin: String?,
                        askingPriceMax: String?,
                        page: String?,
                        perPage: String?,
                        showInactive: Bool?
        ) -> Single<ListBusinessesResponse>
    
    func listSavedBusinesses(authToken: AuthToken,
                             page: String?,
                             perPage: String?) -> Single<ListSavedBusinessesResponse>
    
    func toggleSavedBusiness(authToken: AuthToken,
                             businessId: Int,
                             isToBeSaved: Bool) -> Single<ToggleSavedBusinessResponse>
    
     func getBusinessPromoEmails(authToken: AuthToken,
                                 businessId: Int) -> Single<GetBusinessPromoEmailsResponse>
    
    // MARK: - Dynamic Options
    func listPreDefinedChoices() -> Single<ListPreDefinedChoicesResponse>
    
    func listBusinessSectors() -> Single<ListBusinessSectorsResponse>
    
    func listBusinessCategories() -> Single<ListBusinessCategoriesResponse>
    
    func listBusinessLocations() -> Single<ListBusinessLocationsResponse>
    
    func listBusinessRegions() -> Single<ListBusinessRegionsResponse>
    
    // MARK: - Business Engagements
    func createBusinessEngagement(authToken: AuthToken,
                                  businessId: Int,
                                  message: String) -> Single<CreateBusinessEngagementResponse>
    
    func listBusinessEngagements(authToken: AuthToken,
                                 businessId: String?,
                                 buyerPublicUserId: String?,
                                 isFullDetailsAccessible: Bool?,
                                 isFullDetailsPending: Bool?,
                                 page: String?,
                                 perPage: String?) -> Single<ListBusinessEngagementsResponse>
    
    func createBusinessEngagementViewing(authToken: AuthToken,
                                         businessEngagementId: Int,
                                         dateOption1: String,
                                         timeStartOption1: String,
                                         dateOption2: String,
                                         timeStartOption2: String,
                                         dateOption3: String,
                                         timeStartOption3: String) -> Single<CreateBusinessEngagementViewingResponse>
    
    func listBusinessEngagementViewings(authToken: AuthToken,
                                        businessId: Int?,
                                        buyerPublicUserId: Int?,
                                        perPage: Int?,
                                        page: Int?,
                                        monthYear: String?) -> Single<ListBusinessEngagementViewingsResponse>
    
    func createBusinessEngagementBid(authToken: AuthToken,
                                     businessEngagementId: Int,
                                     bidAmount: Int,
                                     terms: String?,
                                     timescale: String?,
                                     isFundingInPlace: String?) -> Single<CreateBusinessEngagementBidResponse>
    
    
    
    func createBusinessEngagementDocumentRequest(   authToken: AuthToken,
                                                    businessEngagementId: Int,
                                                    type: String,
                                                    year: Int?) -> Single<CreateDocumentRequestResponse>
    
    func reviewEngagement(authToken: AuthToken,
                          businessEngagementId: Int,
                          action: String) -> Single<ReviewBusinessEngagementResponse>
    
    func listBusinessEngagementBids(authToken: AuthToken,
                                    businessId: Int?,
                                    buyerPublicUserId: Int?,
                                    isPending: Bool?,
                                    isRejected: Bool?,
                                    isAccepted: Bool?,
                                    perPage: String,
                                    page: String) -> Single<ListBusinessBidsResponse>
    
    func listBusinessDocuments(authToken: AuthToken,
                               businessId: Int) -> Single<ListDocumentsResponse>

    func createDocument(authToken: AuthToken,
                        businessId: Int,
                        type: String,
                        typeOther: String,
                        year: String,
                        doc: URL?) -> Single<CreateDocumentResponse>
    
    func deleteDocument(authToken: AuthToken,
                        businessDocumentId: Int) -> Single<BasicResponse>


    typealias GetBusinessAddressResponse = AddressResponse
    func getBusinessAddress(authToken: AuthToken,
                            businessId: Int) -> Single<GetBusinessAddressResponse>
    
    typealias EditBusinessAddressResponse = AddressResponse
    func editBusinessAddress(authToken: AuthToken,
                             businessId: Int,
                             line1: String?,
                             line2: String?,
                             line3: String?,
                             townCity: String?,
                             postcode: String?) -> Single<GetBusinessAddressResponse>
    
    
    typealias ChangePasswordResponse = FeedbackResponse
    func changePassword(authToken: AuthToken,
                        password: String,
                        confirmPassword: String
        ) -> Single<ChangePasswordResponse>
    
    
    // MARK: - Profile
    typealias EditProfileResponse = UserResponse
    func editProfile(authToken: AuthToken,
                     firstName: String?,
                     lastName: String?,
                     email: String?,
                     mobileNumber: String?,
                     bio: String?,
                     aboutProfession: String?,
                     location: String?,
                     isPostContactOptedIn: Bool?,
                     isEmailContactOptedIn: Bool?,
                     isSmsContactOptedIn: Bool?,
                     isPhoneContactOptedIn: Bool?,
                     interest_types: Array<InterestTypes>?,
                    image: UIImage?) -> Single<EditProfileResponse>
    
    typealias EditProfileImageResponse = UserResponse
    func editProfileImage(authToken: AuthToken,
                          image: UIImage?) -> Single<EditProfileImageResponse>
    
    // MARK: - Messages
    func listTopLevelMessages(authToken: AuthToken,
                              photoWidth: Int,
                              photoHeight: Int) -> Single<TopLevelMessagesResponse>
    
    func listMessagesByEngagement(authToken: AuthToken,
                                  engagementId: Int,
                                  perPage: Int?,
                                  page: Int?) -> Single<ListMessagesByEngagementResponse>
    
    func createMessage(authToken: AuthToken,
                       engagementId: Int,
                       content: String) -> Single<CreateMessageResponse>
    
    // MARK: - Adverts
    func createAdvert(authToken: AuthToken, advert: AdvertParameters) -> Single<BuildAdvertResponse>
    
    func uploadBusinessPhotos(authToken: AuthToken, businessId: String, files: [String: UIImage]) -> Single<UploadBusinessPhotosResponse>
    
    func submitValuation(authToken: AuthToken,
                        businessSectorId: String,
                        tenure: String,
                        annualTurnover: String,
                        businessPostcode: String?,
                        userName: String?,
                        emailAddress: String?,
                        phoneNumber: String?,
                        widgetValues: [String: String]?
        ) -> Single<CreateBusinessValuationResponse>
    
}
