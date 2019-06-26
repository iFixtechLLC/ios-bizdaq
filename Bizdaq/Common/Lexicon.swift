//
//  Lexicon.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

enum Lexicon {
    
    static let universalError = "Error"
    
    enum Error {
        static let unknownError = "An unknown error occured, please try again."
        static let internetConnection = "Please connect to the internet and try again."
        static let unableToUpdateLexicon = "Please connect to the internet and try again."
        static let LoginToUse = "Please login to use this"
        static let LoginToUseFavourites = "Please login to view your saved favourites"
    }
    
    enum BusinessBrowse {
        static let firstTabTitle = "Browse businesses"
        static let secondTableTitle = "My favourites"
        static let noValuePlaceholder = "N/A"
    }
    
    enum Registration {
        enum Error {
            static let accountExists = "An account with this email address already exists, please try again."
            static let invalidRegistrationCredentials = "Please fill in the necessary fields before proceeding."
        }
        static let success = "Account successfully created."
        static let noValuePlaceholder = "N/A"
        static let firstNamePlaceholder = "First name"
        static let lastNamePlaceholder = "Last name"
        static let mobilePlaceholder = "Mobile number"
        static let emailPlaceholder = "Email"
        static let passwordPlaceholder = "Password"
        static let messagePlaceholder = "Enter your message to the seller (optional)"
    }
    
    enum Login {
        enum Error {
            static let invalidCredentials = "Invalid credentials, please try again or create an account."
        }
        static let emailPlaceholder = "Email"
        static let passwordPlaceholder = "Password"
    }
    
    enum BusinessDetail {
        
        enum Error {
            static let failedToCreateEngagement = "Failed to create engagement, please try again later."
            static let failedToCreateViewing = "Failed to create viewing, please try again later."
        }
        
        static let notLoggedInAccessTitle = "Contact seller"
        static let requestedAccessTitle = "Request pending"
        static let fullAccessTitle = "Full access granted"
        static let restrictedAccessTitle = "Contact seller"
        static let notLoggedInAccessDescription = "To see the full details of this business and contact the seller, register as a buyer."
        static let requestedAccessDescription = "Once the seller has accepted your request, you will gain full access to this business."
        static let fullAccessDescription = ""
        static let restrictedAccessDescription = "Send a message to the business owner and agree to the NDA below to request access to full business details."
        static let messagePlaceholder = "Enter your message to the seller"
        static let arrangeViewing = "Arrange viewing"
        static let keyInfo = "Key info"
        static let makeAnOffer = "Make an offer"
        static let noValue = "N/A"
        static let chooseBusinessPlaceholder = "Choose business"
        static let chooseDatePlaceholder = "Choose date"
        static let chooseTimePlaceholder = "Choose time"
    }
    
    enum BusinessSearch {
        static let sectorPlaceholder = "Choose"
        static let locationPlaceholder = "Choose"
    }
    
    enum BusinessFilter {
        static let sectorPlaceholder = "Choose"
        static let tenurePlaceholder = "Choose"
        static let locationPlaceholder = "Choose"
    }
    
    enum BuildAdvert {
        static let businessTypePlaceholder = "Choose"
        static let propertyTypePlaceholder = "Choose"
        static let postcodePlaceholder = "Postcode"
        static let annualTurnoverPlaceholder = "Annual turnover"
        static let netProfitPlaceholder = "Net profit"
        static let hasStaffPlaceholder = "Choose"
        static let yearEstablishedPlaceholder = "Year established"
        static let askingPricePlaceholder = "Asking price"
        static let headlinePlaceholder = "Type here..."
        static let businessDescriptionPlaceholder = "Type here..."
        static let extendedDescriptionPlaceholder = "Type here..."
    }
    
    enum EmptyState {
        static let noFavourites = "You don’t have any favourites yet."
        static let noResults = "No matching results."
        static let noConnection = "You are not connected to the internet."
        static let noGrantedAccessBusinesses = "You have not yet been granted access to a business listing"
        static let noFavouritesBusinesses = "You have not yet saved any listings to your favourites"
        static let noRequestedAccessBusinesses = "You have not yet requested access to a business listing"
    }
    
    enum Favourites {
        static func removeConfirmationString(businessName: String) -> String {
            return "Are you sure you want to remove \(businessName) from your favourites?"
        }
        static let noName = "N/A"
    }
    
    enum SellersDashboard {
        static let createAdvertTitle = "Create advert"
        static let messagesTitle = "Messages"
        static let keyInfoTitle = "Key info"
        static let offersTitle = "Offers"
        static let upsells = "Upsells"
    }
    
    enum Menu {
        static let createAdvert = "Create advert"
        static let BuyerDashboard = "Buyer Dashboard"
        static let SellerDashboard = "Seller Dashboard"
    }
    
    enum Messages {
        static let searchPlaceholder = "Search messages..."
    }
    
    enum Offers {
        static let firstTabTitle = "Pending"
        static let secondTableTitle = "Rejected"
    }
    
    enum Valuation {
        static let businessTypePlaceholder = "Business Type"
        static let tenurePlaceholder = "Tenure"
    }
    
    enum Documents {
        static let documents = "Documents"
        static let request = "Request Document"
        static let docType = "Document Type"
    }
    
    
    
}
