//
//  ViewModelFactory.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 04/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class ViewModelFactory {
    
    // MARK: - Public Methods
    enum Splash {
        static func makeSplashModel() -> SplashViewModel {
            return SplashViewModel(delay: 0.05)
        }
    }
    
    enum Onboarding {
        static func makeOnboardingModel() -> OnboardingViewModel {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: Bundle.main)
            return OnboardingViewModel(storyboard: storyboard, viewIds: ["view1", "view2", "view3"])
        }
        static func makeOnboardingPageModel(index: Int) -> OnboardingPageViewModel {
            return OnboardingPageViewModel(index: index)
        }
    }
    
    enum Login {
        static func makeLoginModel(modallyPresented: Bool = false) -> LoginViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return LoginViewModel(apiClient: apiClient, modallyPresented: modallyPresented)
        }
        
        static func makeRecoveryModel(modallyPresented: Bool = false) -> ForgotPasswordViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return ForgotPasswordViewModel(apiClient: apiClient)
        }
        
    }
    
    enum Registration {
        static func makeRegistrationModel() -> BuyerRegisterViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return BuyerRegisterViewModel(apiClient: apiClient)
        }
        
        static func makeModalRegistrationModel() -> ModalBuyerRegisterViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return ModalBuyerRegisterViewModel(apiClient: apiClient)
        }
        
        static func makeSellerRegistrationModel() -> SellerRegisterViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return SellerRegisterViewModel(apiClient: apiClient)
        }
    }
    
    enum BusinessSearch {
        static func makeBusinessSearchModel() -> BusinessSearchViewModel {
            return BusinessSearchViewModel()
        }
    }
    
    enum BusinessBrowse {
        static func makeBusinessBrowseModel(filter: BusinessSearchFilter?) -> BusinessBrowseViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            let favouritesManager = FavouritesManager(apiClient: apiClient)
            return BusinessBrowseViewModel(apiClient: apiClient,
                                           authToken: UserSession.shared.authToken,
                                           favouritesManager: favouritesManager,
                                           filter: filter)
        }
        
        static func makeBusinessDetailsModel(authToken: AuthToken?, business: Business) -> BusinessDetailsViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            let engagementManager = BusinessEngagementManager(apiClient: apiClient)
            let favouritesManager = FavouritesManager(apiClient: apiClient)
            let popupManager = PopupManager()
            return BusinessDetailsViewModel(apiClient: apiClient,
                                            authToken: authToken,
                                            engagementManager: engagementManager,
                                            favouritesManager: favouritesManager,
                                            popupManager: popupManager,
                                            business: business)
        }

        static func makeCreateViewingModel(business: Business, engagement: BusinessEngagement) -> CreateViewingViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            let popupManger = PopupManager()
            return CreateViewingViewModel(apiClient: apiClient, business: business, engagement: engagement, popupManager: popupManger)
        }

        static func makeMakeOfferModel(businessEngagementId: Int) -> MakeOfferViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return MakeOfferViewModel(apiClient: apiClient, businessEngagementId: businessEngagementId)
        }
        
        static func makeBusinessFilterModel(filter: BusinessSearchFilter?) -> BusinessBrowseFilterViewModel {
            return BusinessBrowseFilterViewModel(filter: filter)
        }
        
        static func makeFavouritesViewModel(authToken: AuthToken?) -> FavouritesViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            let favouritesManager = FavouritesManager(apiClient: apiClient)
            return FavouritesViewModel(apiClient: apiClient, authToken: authToken, favouritesManager: favouritesManager)
        }
    }
    
    enum Selection {
        static func makeCategoryListModel(selectionHandler: @escaping (_ sector: BusinessSector) -> Void) -> CategoryListViewModel {
            return CategoryListViewModel(selectionHandler: selectionHandler)
        }
        
        static func makeSectorListModel(category: BusinessCategory, selectionHandler: @escaping (_ sector: BusinessSector) -> Void) -> SectorListViewModel {
            return SectorListViewModel(category: category, selectionHandler: selectionHandler)
        }
        
        static func makeRegionListModel(selectionHandler: @escaping (_ location: BusinessLocation) -> Void) -> RegionsListViewModel {
            return RegionsListViewModel(selectionHandler: selectionHandler)
        }
        static func makeRegionOnlyListModel(selectionHandler: @escaping (_ location: BusinessRegion) -> Void) -> RegionsListViewModel {
            return RegionsListViewModel(regionSelectionHandler: selectionHandler)
        }
        
        static func makeLocationListModel(region: BusinessRegion, selectionHandler: @escaping (_ location: BusinessLocation) -> Void) -> LocationListViewModel {
            return LocationListViewModel(region: region, selectionHandler: selectionHandler)
        }
    }
    
    enum BuildAdvert {
        static func makeBuildAdvertViewModel(advertParameters: AdvertParameters?, isModal: Bool) -> BuildAdvertViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return BuildAdvertViewModel(apiClient: apiClient, advertParameters: advertParameters, isModal: isModal)
        }
        
        static func makeAddBusinessPhotosModel(businessId: Int) -> AddPhotosViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return AddPhotosViewModel(apiClient: apiClient, businessId: businessId)
        }
    }
    
    enum BuyersDashboard {
        static func makeBuyersDashboardViewModel(buyerPublicUserId: Int) -> BuyerDashboardViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return BuyerDashboardViewModel(apiClient: apiClient, buyerPublicUserId: buyerPublicUserId)
        }
    }
    
    enum SellersDashboard {
        static func makeSellersDashboardViewModel(sellerPublicProfile: PublicUserSellerProfile) -> SellersDashboardViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return SellersDashboardViewModel(apiClient: apiClient, sellerPublicProfile: sellerPublicProfile)
        }
        
        static func makeBuyerEngagementsViewModel(business: Business) -> BuyerEngagementsViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return BuyerEngagementsViewModel(apiClient: apiClient, business: business)
        }
    }
    
    enum YourAdvert {
        static func makeYourAdvertViewModel(business: Business) -> YourAdvertViewModel {
            return YourAdvertViewModel(business: business)
        }
    }
    
    enum Profile {
        static func makeProfileViewModel(user: User, profileImage: UIImage? = nil,  isProfilePreview: Bool = false) -> ProfileViewModel {
            return ProfileViewModel(user: user, profileImage: profileImage, isProfilePreview: isProfilePreview)
        }
        
        static func makeEditProfileViewModel(user: User) -> EditProfileViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return EditProfileViewModel(apiClient: apiClient, user: user)
        }
        static func makeUserInterestsViewModel(selectionHandler: @escaping (_ interests: [InterestTypes]) -> Void) -> UserInterestsViewModel {
            return UserInterestsViewModel(selectionHandler: selectionHandler)
        }
    }
    
    enum Messages {
        static func makeConversationListModel() -> ConversationListViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return ConversationListViewModel(apiClient: apiClient)
        }
        
        static func makeConversationModel(topLevelMessage: Message, contactImage: UIImage?, userImage: UIImage?) -> ConversationViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return ConversationViewModel(apiClient: apiClient, topLevelMessage: topLevelMessage, contactImage: contactImage, userImage: userImage)
        }
        
        static func makeConversationModelFromEngagement(businessEngagementId: Int, contactImage: UIImage?, userImage: UIImage?) -> ConversationViewModel {
            //SNEAKY Way to intialise message from just business engagement
            let topLevelMessage = Message(businessEngagmentId: businessEngagementId, buyerId: UserSession.shared.user?.publicUser.id ?? 0)
            
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return ConversationViewModel(apiClient: apiClient, topLevelMessage: topLevelMessage, contactImage: contactImage, userImage: userImage)
        }
        
    }
    
    enum Offers {
        static func makePendingOffersModel() -> PendingOffersViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return PendingOffersViewModel(apiClient: apiClient)
        }
        
        static func makeRejectedOffersModel() -> RejectedOffersViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return RejectedOffersViewModel(apiClient: apiClient)
        }
    }
    
    enum Marketing {
        static func makeMarketingModel(authToken: AuthToken, business: Business) -> MarketingViewModel {
            return MarketingViewModel(apiClient: APIClient(httpClient: HTTPClient.shared), authToken: authToken, business: business)
        }
    }
    
    enum Viewings {
        static func makeViewingCalendarModel(authToken: AuthToken) -> ViewingsCalendarViewModel {
            let apiClient = APIClient(httpClient: HTTPClient.shared)
            return ViewingsCalendarViewModel(apiClient: apiClient, authToken: authToken)
        }
    }
    
    enum Valuation {
        static func makeValuationModel(authToken: AuthToken?) -> ValuationViewModel {
            return ValuationViewModel(apiClient: APIClient(httpClient: HTTPClient.shared), authToken: authToken)
        }
        
        static func makeAdditionalValuationModel(authToken: AuthToken?, valuationProperties: ValuationViewModel.InitialValuationProperties, widgets: Widgets, isFreehold: Bool) -> AdditionalValuationViewModel {
            return AdditionalValuationViewModel(apiClient: APIClient(httpClient: HTTPClient.shared), authToken: authToken, valuationProperties: valuationProperties, widgets: widgets, isFreehold: isFreehold)
        }
    }
    enum Documents {
        static func makeDocumentModel() -> DocumentViewModel {
            return DocumentViewModel(apiClient: APIClient(httpClient: HTTPClient.shared))
        }
    }
}
