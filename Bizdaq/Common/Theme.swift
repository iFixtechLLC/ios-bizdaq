//
//  Theme.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

enum Theme {
    
    enum UIElements {
        static let upArrowImage = UIImage(named: "up-arrow")
        static let downArrowImage = UIImage(named: "down-arrow")
        static let defaultBorderColor = UIColor.black.withAlphaComponent(0.15)
        static let blueBorderColor = UIColor(hex: "1E85E0")
        static let lightBlueBorderColor = UIColor(hex: "D3E8F9")
        static let placeholderTextColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
        static let defaultTextColor = UIColor.black
        static let pageIndicatorColor = UIColor(hex: "013C73").withAlphaComponent(0.2)
        static let selectedPageIndicatorColor = UIColor(hex: "013C73")
        static let activeButtonColor = UIColor(hex: "1E85E0")
        static let inactiveButtonColor = UIColor(hex: "37424F")
        static let unselectedButtonImage = UIImage(named: "unselected")
        static let selectedButtonImage = UIImage(named: "selected")
        static let receivedMessageBubbleBackground = UIColor(hex: "F1F0F0")
        static let sentMessageBubbleBackground = UIColor(hex: "ECF6FF")
        static let receivedMessageTextColor = UIColor(hex: "110B32")
        static let sentMessageTextColor = UIColor(hex: "0F84E3")
        static let errorColor = UIColor(hex: "FF0000")
    }
    
    enum Icons {
        static let arrangeViewingIcon = UIImage(named: "arrange_viewing_icon")
        static let keyInfoIcon = UIImage(named: "key_info_icon")
        static let makeOfferIcon = UIImage(named: "make_offer_icon")
        static let currencyIcon = UIImage(named: "currency_icon")
        static let inactiveFavouriteIcon = UIImage(named: "favourite-unselected")
        static let activeFavouriteIcon = UIImage(named: "favourite-selected")
        static let genericErrorImage = UIImage(named: "generic_error")
        static let connectionErrorImage = UIImage(named: "connection_error")
        static let selectedIcon = UIImage(named: "selected")
        static let unselectedIcon = UIImage(named: "unselected")
        static let navigationRightArrowIcon = UIImage(named: "navigation-arrow")
        static let navigationRightArrowGreyIcon = UIImage(named: "navigation-arrow-grey")
        static let menuButtonIcon = UIImage(named: "navigation-menu-button")
        static let imagePlaceholderIcon = UIImage(named: "placeholder")
        static let avatarPlaceholderIcon = UIImage(named: "avatar_placeholder")
        static let navigateBackIcon = UIImage(named: "navigation-back")
    }
    
    enum SellersDashboard {
        static let createAdvertIcon = UIImage(named: "create-advert-icon")
        static let messagesIcon = UIImage(named: "messages-icon")
        static let keyInfoIcon = UIImage(named: "key-info-icon")
        static let offersIcon = UIImage(named: "offers-icon")
        static let upsellsIcon = UIImage(named: "upsells-icon")
    }
    
    enum Menu {
        static let activeButtonColor = UIColor(hex: "1E85E0")
        static let inactiveButtonColor = UIColor(hex: "1E85E0").withAlphaComponent(0.5)
        static let callToActionButtonColor = UIColor(hex: "37424F")
    }
    
    enum BuyersEngagements {
        static let cellBorderColor = UIColor(hex: "D3E8F9")
    }
}
