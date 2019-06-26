//
//  PopupManager.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 19/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

class PopupManager {
    
    func presentMessagePopup(then handler: @escaping (_ message: String) -> Void) {
        let messagePopup = MessagePopup { (message) in
            handler(message)
            Popup.shared.dismiss()
        }
        Popup.shared.setPopupView(messagePopup)
        Popup.shared.present()
    }
    
    func presentViewingCreatedPopup( then handler: @escaping () -> Void) {
        let successPopup = ViewingRequestSentPopup {
            handler()
            Popup.shared.dismiss()
        }
        Popup.shared.setPopupView(successPopup)
        Popup.shared.present()
    }
    
    func presentSimplePopup(then handler: @escaping () -> Void, title: String, description: String) {
        let messagePopup = SimpleMessagePopup {
            handler()
            Popup.shared.dismiss()
        }
        messagePopup.setTitle(title)
        messagePopup.setDescription(description)
        Popup.shared.setPopupView(messagePopup)
        Popup.shared.present()
    }
    
    
    func presentConfirmPopup(then nohandler: @escaping () -> Void, yeshandler: @escaping () -> Void, title: String, description: String) {

        let messagePopup = ConfirmMessagePopup(dismissButtonHandler: {
            nohandler()
        }, goHandler: {
            yeshandler()
        })
        messagePopup.setTitle(title)
        messagePopup.setDescription(description)
        Popup.shared.setPopupView(messagePopup)
        Popup.shared.present()
    }
    
    func presentMessageRequestOptions(then dismissHandler: @escaping () ->Void, requestHandler: @escaping () -> Void, offerHandler: @escaping () ->Void, docHandler: @escaping () ->Void ) {
        let messagePopup = MessageRequestOptionsPopup(dismissButtonHandler: {
            dismissHandler()
        }, viewingHandler: {
            requestHandler()
        }, offerHandler: {
            offerHandler()
        }, docHandler: {
            docHandler()
        })
        Popup.shared.setPopupView(messagePopup)
        Popup.shared.present()
    }
    
    func presentRequestViewingPopup(dismissHandler: @escaping () ->Void, apiClient: APIClient?, authToken:AuthToken?, businessEngagementId: Int?){
        let messagePopup = RequestViewingPopup(dismissButtonHandler: dismissHandler, apiClient: apiClient, authToken:authToken, businessEngagementId: businessEngagementId)
        Popup.shared.setPopupView(messagePopup)
        Popup.shared.present()
    }
    func presentMakeOfferPopup(dismissHandler: @escaping () ->Void, apiClient: APIClient?, authToken:AuthToken?, businessEngagementId: Int?){
        let messagePopup = MakeOfferRequestPopup(dismissButtonHandler: dismissHandler, apiClient: apiClient, authToken:authToken, businessEngagementId: businessEngagementId)
        Popup.shared.setPopupView(messagePopup)
        Popup.shared.present()
    }
    func presentRequestDocPopup(dismissHandler: @escaping () ->Void, apiClient: APIClient?, authToken:AuthToken?, businessEngagementId: Int?){
        let messagePopup = RequestDocumentPopup(dismissButtonHandler: dismissHandler, apiClient: apiClient, authToken:authToken, businessEngagementId: businessEngagementId)
        Popup.shared.setPopupView(messagePopup)
        Popup.shared.present()
    }
    
}
