//
//  RequestOptionsViewController.swift
//  Bizdaq
//
//  Created by App Dev on 14/06/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import RxSwift
import RxCocoa
import JGProgressHUD
import IHKeyboardAvoiding

class RequestOptionsViewController: UIViewController {
    private var engagementId:Int?
    private var viewModel:ConversationViewModel?
    public func setViewModel(vm: ConversationViewModel){
        viewModel = vm
    }

    @IBOutlet weak var hackyText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pum = PopupManager()
        pum.presentMessageRequestOptions(
            then: {
                self.reinitMessageBar()
        }, requestHandler: {
            guard let engagementId = self.viewModel?.topLevelMessage.businessEngagementId else { return }
            pum.presentRequestViewingPopup(
                dismissHandler: {
                    self.reinitMessageBar()
            },
                apiClient: self.viewModel?.getApiClient(),
                authToken: UserSession.shared.authToken,
                businessEngagementId: engagementId)
        }, offerHandler: {
            guard let engagementId = self.viewModel?.topLevelMessage.businessEngagementId else { return }
            pum.presentMakeOfferPopup(
                dismissHandler: {
                    self.reinitMessageBar()
                },
                apiClient: self.viewModel?.getApiClient(),
                authToken: UserSession.shared.authToken,
                businessEngagementId: engagementId)
        }, docHandler: {
            guard let engagementId = self.viewModel?.topLevelMessage.businessEngagementId else { return }
            pum.presentRequestDocPopup(
                dismissHandler: {
                    self.reinitMessageBar()
            },
                apiClient: self.viewModel?.getApiClient(),
                authToken: UserSession.shared.authToken,
                businessEngagementId: engagementId)
        }
        )
    }
    func reinitMessageBar(){
        //UIWindow.
        navigationController?.popViewController(animated: true)
        //navigate(to: .messagesFromRequest, sender: self)
    }
    @IBAction func hackyTextEditingStarted(_ sender: Any) {
        
        print("STARTED EDITING")
    }
    
}

// MARK: - Navigation
extension RequestOptionsViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case messagesFromRequest
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .messagesFromRequest:
            guard let destination = segue.destination as? ConversationViewController else { preconditionFailure() }

            
            destination.attach(to: ViewModelFactory.Messages.makeConversationModel(
                topLevelMessage: viewModel!.topLevelMessage,
                contactImage: viewModel?.contactImage,
                userImage: viewModel?.userImage)
            )
        }
    }
}
