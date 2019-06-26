//
//  APIClient.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

final class APIClient: APIProtocol {
   
   
    
    // MARK: - Properties
    let httpClient: HTTPProtocol
    
    enum EndpointPath {
        static let registerBuyer = "/register"
        static let registerSeller = "/seller-build-advert/register"
        static let login = "/login"
        static let listBusinesses = "/list-businesses"
        static let listPreDefinedChoices = "/list-pre-defined-choices"
        static let listBusinessSectors = "/list-business-sectors"
        static let listBusinessCategories = "/list-business-categories"
        static let listBusinessLocations = "/list-business-locations"
        static let listBusinessRegions = "/list-business-regions"
        static let createBusinessEngagement = "/create-business-engagement"
        static let listBusinessEngagements = "/list-business-engagements"
        static let listBusinessEngagementViewings = "/list-business-engagement-viewings"
        static let createBusinessEngagementViewing = "/create-business-engagement-viewing"
        
        static let toggleSavedBusiness = "/toggle-saved-business"
        static let listSavedBusinesses = "/list-saved-businesses" //deprecated
        static let createBusinessEngagementBid = "/create-business-engagement-bid"
        static let reviewBusinesssEngagement = "/review-business-engagement"
        static let updateProfile = "/update-profile"
        static let changePassword = "/change-password"
        static let listTopLevelMessages = "/list-top-level-messages"
        static let listBusinessEngagementBids = "/list-business-engagement-bids"
        static let buildAdvert = "/seller-build-advert/add-business"
        static let editAdvert = "/seller-build-advert/edit-business"
        static let uploadBusinessPhotos = "/upload-business-photo"
        static let listMessagesByEngagement = "/list-messages"
        static let createMessage = "/create-message"
        static let getBusinessAddress = "/get-business-address"
        static let editBusinessAddress = "/update-business-address"
        static let getBusinessPromoEmails = "/get-business-promo-emails"
        static let valuation = "/valuation"
        static let listDocuments = "/list-business-documents"
        static let createDocument = "/create-business-document"
        static let deleteDocument = "/delete-business-document"
        static let createDocumentRequest = "/create-business-engagement-document-request"
        static let forgotPassword = "/forgot-password"
    }
    
    enum Parameters {
        enum RegisterBuyer {
            static let firstName = "first_name"
            static let lastName = "last_name"
            static let mobilePhone = "mobile_phone"
            static let emailAddress = "email_address"
            static let password = "password"
            static let howDidYouHearAboutUs = "how_did_you_hear_about_us"
            static let businessSectorsOfInterest = "business_sectors_of_interest"
        }
        enum RegisterSeller {
            static let firstName = "first_name"
            static let lastName = "last_name"
            static let mobilePhone = "mobile_phone"
            static let emailAddress = "email_address"
            static let password = "password"
        }
        enum Login {
            static let emailAddress = "email_address"
            static let password = "password"
        }
        enum ChangePassword{
            static let password = "password"
            static let confirmPassword = "confirm_password"
        }
        enum ListBusinesses {
            static let authToken = "auth_token"
            static let sellerPublicUserId = "seller_public_user_id"
            static let sectorId = "business_sector_id"
            static let categoryId = "business_category_id"
            static let locationId = "business_location_id"
            static let tenure = "tenure"
            static let askingPriceMin = "asking_price_min"
            static let askingPriceMax = "asking_price_max"
            static let showInactive = "show_inactive_listings"
            static let isSaved = "is_saved"
        }
        enum BusinessAddress {
            static let businessId = "business_id"
            static let line1 = "line1"
            static let line2 = "line2"
            static let line3 = "line3"
            static let townCity = "town_city"
            static let postcode = "postcode"
        }
        enum BusinessEngagement {
            static let businessId = "business_id"
            static let message = "message"
            static let buyerPublicUserId = "buyer_public_user_id"
            static let isFullDetailsAccessible = "is_full_details_accessible"
            static let isFullDetailsPending = "is_full_details_pending"
            static let dateOption1 = "date_option1"
            static let timeStartOption1 = "time_start_option1"
            static let dateOption2 = "date_option2"
            static let timeStartOption2 = "time_start_option2"
            static let dateOption3 = "date_option3"
            static let timeStartOption3 = "time_start_option3"
            static let businessEngagementId = "business_engagement_id"
            static let bidAmount = "bid_amount"
            static let terms = "terms"
            static let timescale = "timescale"
            static let isFundingInPlace = "is_funding_in_place"
            static let action = "action"
            static let isPending = "is_pending"
            static let isRejected = "is_rejected"
            static let isAccepted = "is_accepted"
            static let monthYear = "month_year"
            
        }
        enum Profile {
            static let firstName = "first_name"
            static let lastName = "last_name"
            static let email = "email"
            static let mobileNumber = "mobile_number"
            static let bio = "bio"
            static let aboutProfession = "about_profession"
            static let location = "location"
            static let profileImage = "profile_image"
            static let isPostContactOptedIn = "is_post_contact_opted_in"
            static let isEmailContactOptedIn = "is_email_contact_opted_in"
            static let isSmsContactOptedIn = "is_sms_contact_opted_in"
            static let isPhoneContactOptedIn = "is_phone_contact_opted_in"
            static let publicUserInterestTypes = "public_user_interest_types"
        }
        enum Messages {
            static let photoWidth = "photo_wdith"
            static let photoHeight = "photo_height"
            static let businessEngagementId = "business_engagement_id"
            static let content = "content"
        }
        enum Advert {
            static let businessSectorId = "business_sector_id"
            static let tenure = "tenure"

            static let postcode = "postcode"
            static let annualTurnover = "annual_turnover"
            static let netProfit = "net_profit"
            static let hasStaff = "has_staff"
            static let yearBusinessEstablished = "year_business_established"
            static let askingPrice = "asking_price"
            static let isOpenToOffers = "is_open_to_offers"
            static let advertHeadline = "advert_headline"
            static let opportunity = "opportunity"
            static let property = "property"
            static let businessId = "business_id"
            static let propertyHasAccomodation = "property_has_accommodation"
            static let propertyRentPerAnnum = "property_rent_per_annum"
            static let propertyFreeholdValue = "property_freehold_value"
            static let isBusinessLocationConfidential = "is_business_location_confidential"
            static let isStockValueAdded = "is_stock_at_value_added"
            static let isBusinessPhotoConfidential = "is_business_photo_confidential"
            static let situation = "situation"
            
        }

        enum Valuation {
            static let authToken = "auth_token"
            static let businessSectorId = "business_sector_id"
            static let tenure = "tenure"
            static let annualTurnover = "annual_turnover"
            static let businessPostcode = "business_postcode"
            static let anonymousUserName = "anonymous_user_name"
            static let anonymousUserEmailAddress = "anonymous_user_email_address"
            static let anonymousPhoneNumber = "anonymous_phone_number"
            static let basicBusinessValuationPropertyFreehold = "basic_business_valuation_property_freehold"
        }
        enum Documents {
            static let authToken = "auth_token"
            static let businessId = "business_id"
            static let type = "type"
            static let typeOther = "type_other"
            static let year = "year"
            static let file = "file"
            static let businessDocumentId = "business_document_id"

        }
        enum Pagination {
            static let perPage = "per_page"
            static let page = "page"
        }
    }
    
    typealias Headers = [String: String]
    var httpHeaders: Headers {
        if Constants.Networking.development {
            return [
                "BIZDAQ-AUTH-KEY": Constants.Networking.bizdaqKey,
                "Authorization": "Basic Yml6ZGFxOmxldG1laW5iaXpkYXE"
                
            ]
        }
        return [
            "BIZDAQ-AUTH-KEY": Constants.Networking.bizdaqKey,
        ]
        
    }
    
    // MARK: - Lifecycle
    init(httpClient: HTTPProtocol) {
        self.httpClient = httpClient
    }
    
    // MARK: - Public Methods
    func registerBuyer(firstName: String,
                       lastName: String,
                       mobilePhone: String,
                       emailAddress: String,
                       password: String,
                       howDidYouHearAboutUs: String?,
                       businessSectorsOfInterest: [String]?) -> Single<APIProtocol.RegisterBuyerResponse> {
        var params: [String : Any] = [Parameters.RegisterBuyer.firstName: firstName,
                                      Parameters.RegisterBuyer.lastName: lastName,
                                      Parameters.RegisterBuyer.mobilePhone: mobilePhone,
                                      Parameters.RegisterBuyer.emailAddress: emailAddress,
                                      Parameters.RegisterBuyer.password: password]
        if howDidYouHearAboutUs != nil { params[Parameters.RegisterBuyer.howDidYouHearAboutUs] = howDidYouHearAboutUs }
        if businessSectorsOfInterest != nil { params[Parameters.RegisterBuyer.businessSectorsOfInterest] = businessSectorsOfInterest }
        return httpClient.post(endpoint: EndpointPath.registerBuyer, params: params, headers: httpHeaders)
    }
    
    func registerSeller(firstName: String,
                        lastName: String,
                        mobilePhone: String,
                        emailAddress: String,
                        password: String) -> Single<RegisterSellerResponse> {
        let params: [String: Any] = [Parameters.RegisterSeller.firstName: firstName,
                                     Parameters.RegisterSeller.lastName: lastName,
                                     Parameters.RegisterSeller.mobilePhone: mobilePhone,
                                     Parameters.RegisterSeller.emailAddress: emailAddress,
                                     Parameters.RegisterSeller.password: password]
        return httpClient.post(endpoint: EndpointPath.registerSeller, params: params, headers: httpHeaders)
    }
    
    func login(emailAddress: String, password: String) -> Single<APIProtocol.LoginResponse> {
        let params: [String : Any] = [Parameters.Login.emailAddress: emailAddress,
                                      Parameters.Login.password: password]
        return httpClient.post(endpoint: EndpointPath.login, params: params, headers: httpHeaders)
    }
    func recoverPassword(emailAddress: String) -> Single<BasicResponse> {
        let params: [String : Any] = [Parameters.Login.emailAddress: emailAddress]
        return httpClient.post(endpoint: EndpointPath.forgotPassword, params: params, headers: httpHeaders)
    }

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
                        showInactive: Bool?) -> Single<ListBusinessesResponse> {
        var params = [String: Any]()
        if authToken != nil { params[Parameters.ListBusinesses.authToken] = authToken! }
        if sellerPublicUserId != nil { params[Parameters.ListBusinesses.sellerPublicUserId] = sellerPublicUserId! }
        if sectorId != nil { params[Parameters.ListBusinesses.sectorId] = sectorId! }
        if categoryId != nil { params[Parameters.ListBusinesses.categoryId] = categoryId! }
        if locationId != nil { params[Parameters.ListBusinesses.locationId] = locationId! }
        if tenure != nil { params[Parameters.ListBusinesses.tenure] = tenure! }
        if askingPriceMin != nil { params[Parameters.ListBusinesses.askingPriceMin] = askingPriceMin! }
        if askingPriceMax != nil { params[Parameters.ListBusinesses.askingPriceMax] = askingPriceMax! }
        if showInactive != nil { params[Parameters.ListBusinesses.showInactive] = showInactive! }

        if page != nil { params[Parameters.Pagination.page] = page! }
        if perPage != nil { params[Parameters.Pagination.perPage] = perPage }
        return httpClient.get(endpoint: EndpointPath.listBusinesses, params: params, headers: httpHeaders)
    }
    func listSavedBusinesses(authToken: AuthToken,
                             page: String?,
                             perPage: String?) -> Single<ListSavedBusinessesResponse> {
            var params = [String: Any]()
            params[Parameters.ListBusinesses.authToken] = authToken
            params[Parameters.ListBusinesses.isSaved] = true
            if page != nil { params[Parameters.Pagination.page] = page! }
            if perPage != nil { params[Parameters.Pagination.perPage] = perPage }
            return httpClient.get(endpoint: EndpointPath.listBusinesses, params: params, headers: httpHeaders)
    }
    //Deprecated
//    func listSavedBusinesses(authToken: AuthToken,
//                             page: String?,
//                             perPage: String?) -> Single<ListSavedBusinessesResponse> {
//        let endPoint = "\(EndpointPath.listSavedBusinesses)/\(authToken)"
//        var params = [String: Any]()
//        params[Parameters.Pagination.page] = page ?? ""
//        params[Parameters.Pagination.perPage] = perPage ?? ""
//        return httpClient.get(endpoint: endPoint, params: params, headers: httpHeaders)
//    }
    
    func toggleSavedBusiness(authToken: AuthToken, businessId: Int, isToBeSaved: Bool) -> Single<ToggleSavedBusinessResponse> {
        let endPoint = "\(EndpointPath.toggleSavedBusiness)/\(authToken)/\(businessId)/\(isToBeSaved ? 1 : 0)"
        return httpClient.get(endpoint: endPoint, params: nil, headers: httpHeaders)
    }
    
    func getBusinessPromoEmails(authToken: AuthToken,
                                businessId: Int) -> Single<GetBusinessPromoEmailsResponse> {
        let endPoint = "\(EndpointPath.getBusinessPromoEmails)/\(authToken)/\(businessId)"
        return httpClient.get(endpoint: endPoint, params: nil, headers: httpHeaders)
    }
    
    // MARK: - Dynamic Options
    func listPreDefinedChoices() -> Single<ListPreDefinedChoicesResponse> {
        return httpClient.get(endpoint: EndpointPath.listPreDefinedChoices, params: nil, headers: httpHeaders)
    }
    
    func listBusinessSectors() -> Single<ListBusinessSectorsResponse> {
        let params: [String : Any] = [Parameters.Pagination.page: 1,
                                      Parameters.Pagination.perPage: 1000]
        return httpClient.get(endpoint: EndpointPath.listBusinessSectors, params: params, headers: httpHeaders)
    }
    
    func listBusinessCategories() -> Single<ListBusinessCategoriesResponse> {
        let params: [String : Any] = [Parameters.Pagination.page: 1,
                                      Parameters.Pagination.perPage: 1000]
        return httpClient.get(endpoint: EndpointPath.listBusinessCategories, params: params, headers: httpHeaders)
    }
    
    func listBusinessLocations() -> Single<ListBusinessLocationsResponse> {
        let params: [String : Any] = [Parameters.Pagination.page: 1,
                                      Parameters.Pagination.perPage: 1000]
        return httpClient.get(endpoint: EndpointPath.listBusinessLocations, params: params, headers: httpHeaders)
    }
    
    func listBusinessRegions() -> Single<ListBusinessRegionsResponse> {
        let params: [String : Any] = [Parameters.Pagination.page: 1,
                                      Parameters.Pagination.perPage: 1000]
        return httpClient.get(endpoint: EndpointPath.listBusinessRegions, params: params, headers: httpHeaders)
    }
    
    func listBusinessDocuments(authToken: AuthToken,
                               businessId: Int) -> Single<ListDocumentsResponse> {
        let params: [String : Any] = [Parameters.Pagination.page: 1,
                                      Parameters.Pagination.perPage: 1000]
        let endPoint = "\(EndpointPath.listDocuments)/\(authToken)/\(businessId)"
        return httpClient.get(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    // MARK: - Business Engagement
    func createDocument(authToken: AuthToken,
                                  businessId: Int,
                                  type: String,
                                  typeOther: String,
                                  year: String,
                                  doc: URL?) -> Single<CreateDocumentResponse> {
        let params: [String : Any] = [
            Parameters.Documents.businessId: businessId,
            Parameters.Documents.type: type,
            //Parameters.Documents.typeOther: typeOther,
            Parameters.Documents.year: year
        ]
        let endPoint = "\(EndpointPath.createDocument)/\(authToken)"
        let paramsString = params.mapValues { (value) in
            return String(describing: value)
        }

        return httpClient.upload(endpoint: endPoint, params: paramsString, documents: [Parameters.Documents.file: doc!], headers: httpHeaders, method: .post)
        //return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    // MARK: - Business Engagement
    func deleteDocument(authToken: AuthToken,
                                  businessDocumentId: Int) -> Single<BasicResponse> {
        let endPoint = "\(EndpointPath.deleteDocument)/\(authToken)/\(businessDocumentId)"
        let params = [String : Any]()

        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    
    // MARK: - Business Engagement
    func createBusinessEngagement(authToken: AuthToken,
                                  businessId: Int,
                                  message: String) -> Single<CreateBusinessEngagementResponse> {
        let params: [String : Any] = [Parameters.BusinessEngagement.message: message]
        let endPoint = "\(EndpointPath.createBusinessEngagement)/\(authToken)/\(businessId)"
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    func listBusinessEngagements(authToken: AuthToken,
                                 businessId: String?,
                                 buyerPublicUserId: String?,
                                 isFullDetailsAccessible: Bool?,
                                 isFullDetailsPending: Bool?,
                                 page: String?,
                                 perPage: String?) -> Single<ListBusinessEngagementsResponse> {
        var params = [String : Any]()
        if businessId != nil { params[Parameters.BusinessEngagement.businessId] = businessId! }
        if buyerPublicUserId != nil { params[Parameters.BusinessEngagement.buyerPublicUserId] = buyerPublicUserId! }
        if isFullDetailsAccessible != nil { params[Parameters.BusinessEngagement.isFullDetailsAccessible] = isFullDetailsAccessible!}
        if isFullDetailsPending != nil { params[Parameters.BusinessEngagement.isFullDetailsPending] = isFullDetailsPending! }
        if perPage != nil { params[Parameters.Pagination.perPage] = perPage! }
        if page != nil { params[Parameters.Pagination.page] = page! }
        let endPoint = "\(EndpointPath.listBusinessEngagements)/\(authToken)"
        return httpClient.get(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    func createBusinessEngagementDocumentRequest(   authToken: AuthToken,
                                                    businessEngagementId: Int,
                                                    type: String,
                                                    year: Int?) -> Single<CreateDocumentRequestResponse> {
        var params: [String : Any] = [Parameters.Documents.type: type,
                                      Parameters.Documents.typeOther: ""]
        if year != nil { params[Parameters.Documents.year] = year! }
        let endPoint = "\(EndpointPath.createDocumentRequest)/\(authToken)/\(businessEngagementId)"
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
        
    }
    func createBusinessEngagementViewing(authToken: AuthToken,
                                         businessEngagementId: Int,
                                         dateOption1: String,
                                         timeStartOption1: String,
                                         dateOption2: String,
                                         timeStartOption2: String,
                                         dateOption3: String,
                                         timeStartOption3: String) -> Single<CreateBusinessEngagementViewingResponse> {
        let params: [String : Any] = [Parameters.BusinessEngagement.dateOption1: dateOption1,
                                      Parameters.BusinessEngagement.timeStartOption1: timeStartOption1,
                                      Parameters.BusinessEngagement.dateOption2: dateOption2,
                                      Parameters.BusinessEngagement.timeStartOption2: timeStartOption2,
                                      Parameters.BusinessEngagement.dateOption3: dateOption3,
                                      Parameters.BusinessEngagement.timeStartOption3: timeStartOption3]
        let endPoint = "\(EndpointPath.createBusinessEngagementViewing)/\(authToken)/\(businessEngagementId)"
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    func listBusinessEngagementViewings(authToken: AuthToken,
                                        businessId: Int?,
                                        buyerPublicUserId: Int?,
                                        perPage: Int?,
                                        page: Int?,
                                        monthYear: String?) -> Single<ListBusinessEngagementViewingsResponse> {
        var params = [String : Any]()
        if businessId != nil { params[Parameters.BusinessEngagement.businessId] = businessId! }
        if buyerPublicUserId != nil { params[Parameters.BusinessEngagement.buyerPublicUserId] = buyerPublicUserId! }
        if perPage != nil { params[Parameters.Pagination.perPage] = perPage! }
        if page != nil { params[Parameters.Pagination.page] = page! }
        if monthYear != nil { params[Parameters.BusinessEngagement.monthYear] = monthYear! }
        let endPoint = "\(EndpointPath.listBusinessEngagementViewings)/\(authToken)"
        return httpClient.get(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    func createBusinessEngagementBid(authToken: AuthToken,
                                     businessEngagementId: Int,
                                     bidAmount: Int,
                                     terms: String?,
                                     timescale: String?,
                                     isFundingInPlace: String?) -> Single<CreateBusinessEngagementBidResponse> {
        var params: [String : Any] = [Parameters.BusinessEngagement.businessEngagementId: businessEngagementId,
                                      Parameters.BusinessEngagement.bidAmount: bidAmount]
        if terms != nil { params[Parameters.BusinessEngagement.terms] = terms }
        if timescale != nil { params[Parameters.BusinessEngagement.timescale] = timescale }
        if isFundingInPlace != nil { params[Parameters.BusinessEngagement.isFundingInPlace] = isFundingInPlace }
        let endPoint = "\(EndpointPath.createBusinessEngagementBid)/\(authToken)/\(businessEngagementId)"
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    func reviewEngagement(authToken: AuthToken,
                          businessEngagementId: Int,
                          action: String) -> Single<ReviewBusinessEngagementResponse> {
        let endPoint = "\(EndpointPath.reviewBusinesssEngagement)/\(authToken)/\(businessEngagementId)/\(action)"
        return httpClient.get(endpoint: endPoint, params: nil, headers: httpHeaders)
    }
    
    func listBusinessEngagementBids(authToken: AuthToken,
                                    businessId: Int?,
                                    buyerPublicUserId: Int?,
                                    isPending: Bool?,
                                    isRejected: Bool?,
                                    isAccepted: Bool?,
                                    perPage: String,
                                    page: String) -> Single<ListBusinessBidsResponse> {
        var params: [String: Any] = [Parameters.Pagination.perPage: perPage,
                                     Parameters.Pagination.page: page]
        if businessId != nil { params[Parameters.BusinessEngagement.businessId] = businessId! }
        if buyerPublicUserId != nil { params[Parameters.BusinessEngagement.businessEngagementId] = buyerPublicUserId! }
        if isPending != nil { params[Parameters.BusinessEngagement.isPending] = isPending! }
        if isRejected != nil { params[Parameters.BusinessEngagement.isRejected] = isRejected! }
        if isAccepted != nil { params[Parameters.BusinessEngagement.isAccepted] = isAccepted! }
        let endPoint = "\(EndpointPath.listBusinessEngagementBids)/\(authToken)"
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    func getBusinessAddress(authToken: AuthToken, businessId: Int) -> Single<APIProtocol.GetBusinessAddressResponse> {
        let params: [String: Any] = [Parameters.BusinessAddress.businessId: businessId]
        let endPoint = "\(EndpointPath.getBusinessAddress)/\(authToken)"
        return httpClient.get(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    func editBusinessAddress(authToken: AuthToken,
                             businessId: Int,
                             line1: String?,
                             line2: String?,
                             line3: String?,
                             townCity: String?,
                             postcode: String?) -> Single<APIProtocol.GetBusinessAddressResponse> {
        var params: [String: Any] = [Parameters.BusinessAddress.businessId: businessId]
        if line1 != nil { params[Parameters.BusinessAddress.line1] = line1! }
        if line2 != nil { params[Parameters.BusinessAddress.line2] = line2! }
        if line3 != nil { params[Parameters.BusinessAddress.line3] = line3! }
        if townCity != nil { params[Parameters.BusinessAddress.townCity] = townCity! }
        if postcode != nil { params[Parameters.BusinessAddress.postcode] = postcode! }
        let endPoint = "\(EndpointPath.editBusinessAddress)/\(authToken)/\(businessId)"
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    // MARK: - Profile
    func changePassword(authToken: AuthToken,
                        password: String,
                        confirmPassword: String) -> Single<APIProtocol.ChangePasswordResponse> {
        let params: [String : Any] = [Parameters.ChangePassword.password: password,
                                      Parameters.ChangePassword.confirmPassword: confirmPassword]
        let endPoint = "\(EndpointPath.changePassword)/\(authToken)"
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    
    
    // MARK: - Profile
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
                     image: UIImage? = nil) -> Single<APIProtocol.EditProfileResponse> {
        var params = [String : Any]()
        if firstName != nil { params[Parameters.Profile.firstName] = firstName! }
        if lastName != nil { params[Parameters.Profile.lastName] = lastName! }
        if email != nil { params[Parameters.Profile.email] = email! }
        if mobileNumber != nil { params[Parameters.Profile.mobileNumber] = mobileNumber! }
        if bio != nil { params[Parameters.Profile.bio] = bio!}
        if aboutProfession != nil { params[Parameters.Profile.aboutProfession] = aboutProfession! }
        if location != nil { params[Parameters.Profile.location] = location! }
        let jsonEncoder = JSONEncoder()
        do {
            let json_interest_types = try jsonEncoder.encode(interest_types)
            if let it = String(data: json_interest_types, encoding: .utf8) {
                params[Parameters.Profile.publicUserInterestTypes] = it
            }
        } catch {
            debugPrint("ERROR")
            
        }
        
        if isPostContactOptedIn != nil { params[Parameters.Profile.isPostContactOptedIn] = isPostContactOptedIn! }
        if isEmailContactOptedIn != nil { params[Parameters.Profile.isEmailContactOptedIn] = isEmailContactOptedIn! }
        if isSmsContactOptedIn != nil { params[Parameters.Profile.isSmsContactOptedIn] = isSmsContactOptedIn! }
        if isPhoneContactOptedIn != nil { params[Parameters.Profile.isPhoneContactOptedIn] = isPhoneContactOptedIn }
        params[Parameters.Profile.profileImage] = String.empty
        
        let endPoint = "\(EndpointPath.updateProfile)/\(authToken)"
        if image != nil {
             let paramsString = params.mapValues { (value) in
                return String(describing: value)
            }
            
            return httpClient.upload(endpoint: endPoint, params: paramsString, images: [Parameters.Profile.profileImage: image!], headers: httpHeaders, method: .post)
        } else {
            return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
        }
        //        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    func editProfileImage(authToken: AuthToken,
                          image: UIImage?) -> Single<APIProtocol.EditProfileImageResponse> {
        let endPoint = "\(EndpointPath.updateProfile)/\(authToken)"
        if image != nil {
            return httpClient.upload(endpoint: endPoint, params: nil, images: [Parameters.Profile.profileImage: image!], headers: httpHeaders, method: .post)
        } else {
            return httpClient.post(endpoint: endPoint, params: [Parameters.Profile.profileImage: String.empty], headers: httpHeaders)
        }
    }
    
    // MARK: - Messages
    func listTopLevelMessages(authToken: AuthToken, photoWidth: Int, photoHeight: Int) -> Single<TopLevelMessagesResponse> {
        let params: [String : Any] = [Parameters.Messages.photoWidth: photoWidth,
                                      Parameters.Messages.photoHeight: photoHeight]
        let endPoint = "\(EndpointPath.listTopLevelMessages)/\(authToken)"
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    func listMessagesByEngagement(authToken: AuthToken, engagementId: Int, perPage: Int?, page: Int?) -> Single<ListMessagesByEngagementResponse> {
        var params: [String : Any] = [Parameters.Messages.businessEngagementId: engagementId]
        if perPage != nil { params[Parameters.Pagination.perPage] = perPage! }
        if page != nil { params[Parameters.Pagination.page] = page! }
        let endPoint = "\(EndpointPath.listMessagesByEngagement)/\(authToken)/\(engagementId)"
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    
    func createMessage(authToken: AuthToken, engagementId: Int, content: String) -> Single<CreateMessageResponse> {
        let params: [String : Any] = [Parameters.Messages.content: content]
        let endPoint = "\(EndpointPath.createMessage)/\(authToken)/\(engagementId)"
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    
    // MARK: - Adverts
    func createAdvert(authToken: AuthToken, advert: AdvertParameters) -> Single<BuildAdvertResponse> {
        var params = [String : Any]()
        if let sectorId = advert.businessSectorId { params[Parameters.Advert.businessSectorId] = sectorId }
        if let tenure = advert.tenure { params[Parameters.Advert.tenure] = tenure }
        if let postcode = advert.postcode { params[Parameters.Advert.postcode] = postcode }
        if let annualTurnover = advert.annualTurnover { params[Parameters.Advert.annualTurnover] = annualTurnover }
        if let netProfit = advert.netProfit { params[Parameters.Advert.netProfit] = netProfit }
        if let hasStaff = advert.hasStaff { params[Parameters.Advert.hasStaff] = hasStaff }
        if let yearEstablished = advert.yearBusinessEstablished { params[Parameters.Advert.yearBusinessEstablished] = yearEstablished }
        params[Parameters.Advert.isOpenToOffers] = advert.isOpenToOffers
        if !advert.isOpenToOffers {
        }
        if let askingPrice = advert.askingPrice { params[Parameters.Advert.askingPrice] = askingPrice }
        if let propertyHasAccomodation = advert.propertyHasAccommodaton { params[Parameters.Advert.propertyHasAccomodation] = propertyHasAccomodation }
        if let headline = advert.advertHeadline { params[Parameters.Advert.advertHeadline] = headline }
        if let opportunity = advert.opportunity { params[Parameters.Advert.opportunity] = opportunity }
        if let property = advert.property { params[Parameters.Advert.property] = property }
        
        var endPoint = "\(EndpointPath.buildAdvert)/\(authToken)"
        if advert.businessId != nil && (advert.businessId ?? 0) > 0 {
            let businessId = advert.businessId!
            endPoint = "\(EndpointPath.editAdvert)/\(authToken)/\(String(describing: businessId))"
        }
        return httpClient.post(endpoint: endPoint, params: params, headers: httpHeaders)
    }
    


    
    func uploadBusinessPhotos(authToken: AuthToken, businessId: String, files: [String: UIImage]) -> Single<UploadBusinessPhotosResponse> {
        let params: [String : String] = [Parameters.Advert.businessId: businessId]
        let endPoint = "\(EndpointPath.uploadBusinessPhotos)/\(authToken)/\(businessId)"
        return httpClient.upload(endpoint: endPoint, params: params, images: files, headers: httpHeaders, method: .post)
    }
    
    
    
    
    
    func submitValuation(authToken: AuthToken,
                               businessSectorId: String,
                               tenure: String,
                               annualTurnover: String,
                               businessPostcode: String?,
                               userName: String?,
                               emailAddress: String?,
                               phoneNumber: String?,
                               widgetValues: [String: String]? = nil
        ) -> Single<CreateBusinessValuationResponse> {
        var params = [String : Any]()
        params[Parameters.Valuation.authToken] = authToken
        params[Parameters.Valuation.businessSectorId] = businessSectorId
        params[Parameters.Valuation.tenure] = tenure
        params[Parameters.Valuation.annualTurnover] = annualTurnover
        if businessPostcode != nil { params[Parameters.Valuation.businessPostcode] = businessPostcode }
        if userName != nil { params[Parameters.Valuation.anonymousUserName] = userName! }
        if emailAddress != nil { params[Parameters.Valuation.anonymousUserEmailAddress] = emailAddress! }
        if phoneNumber != nil { params[Parameters.Valuation.anonymousPhoneNumber] = phoneNumber }
        //let endPoint = "\(EndpointPath.valuation)/\(authToken)"
        if widgetValues != nil {
            widgetValues?.forEach { (name, value) in
                params[name] = value
                debugPrint("("+name+", "+value+")")
            }
        }
        
        return httpClient.post(endpoint: EndpointPath.valuation, params: params, headers: httpHeaders)
    }
    
    
    
    #warning("Update legacy endpoints to work with new methods")
    // MARK: - New API Client
    enum APIClientError: Error {
        case invalidURL
        case notConnected
        case decodeFailed
        case unknown
    }
    
    func post<T>(_ endpoint: Endpoint) -> Single<T> where T: Decodable {
        guard let url = endpoint.url?.absoluteString else {
            debugPrint("INVALID URL")
            return Single.error(APIClientError.invalidURL)
        }
        return request(url: url, params: nil, headers: httpHeaders, method: .post)
    }
    
    private func request<T>(url: String, params: Parameters?, headers: HTTPHeaders, method: HTTPMethod) -> Single<T> where T: Decodable {
        let observable = PublishSubject<T>()
        Alamofire.request(url,
                          method: method,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: headers).responseJSON { [weak self] (response) in
            guard let `self` = self else { observable.onError(APIClientError.unknown); return }
            switch self.handle(response, responseType: T.self) {
                case .success(let value):
                    self.printSuccess(url)
                    observable.onNext(value)
                    observable.onCompleted()
                case .error(let error):
                    debugPrint(error)
                    self.printError(url)
                    observable.onError(error)
            }
        }
        return observable.asSingle()
    }
    
    enum Result<T: Decodable> {
        case success(value: T)
        case error(error: Error)
    }
    
    private func handle<T: Decodable>(_ response: DataResponse<Any>, responseType: T.Type) -> Result<T> {
        if(Constants.Networking.silentish == false){
            debugPrint(response)
        }
        switch response.result {
        case .success(_):
            let jsonDecoder = JSONDecoder()
            do {
                debugPrint("startingDecode")
                let response = try jsonDecoder.decode(T.self, from: response.data!)
                return Result.success(value: response)
            } catch let error {
                debugPrint("CAUGHT ERROR:")
                debugPrint(error)
                return Result.error(error: APIClientError.decodeFailed)
            }
        case .failure(let error):
            debugPrint("CAUGHT FAILURE:")
            debugPrint(error)
            if let `error` = error as? URLError, error.code == .notConnectedToInternet {
                return Result.error(error: APIClientError.notConnected)
            } else {
                return Result.error(error: APIClientError.unknown)
            }
        
        }
    }
}

extension APIClient {
    private func printSuccess(_ url: String) {
        debugPrint("🌐 NETWORK REQUEST -> 😃 SUCCESS")
        debugPrint("\(url)")
    }
    
    private func printError(_ url: String) {
        debugPrint("🌐 NETWORK REQUEST -> 😭 ERROR")
        debugPrint("\(url)")
    }
}
