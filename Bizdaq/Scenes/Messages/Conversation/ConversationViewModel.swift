//
//  ConversationViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import MessageKit
import RxSwift
import RxCocoa

class ConversationViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient
    let topLevelMessage: Message
    let contactImage: UIImage?
    let userImage: UIImage?
    
    private let historyMessageCount = 200
    private let pollMessageCount = 10
    private let pollingInterval = 100
    internal enum ChatMessageSubtype {
        case none()
        case message()
        case notification()
        case document(CGFloat)
        case accessBusinessEngagement(Int)
        case accessSomethingElse()
    }


    struct MessageModel: MessageType {
        var sender: Sender
        var messageId: String
        var sentDate: Date
        var kind: MessageKind
        var subType:ChatMessageSubtype
    }
    
    private var messages = [ConversationViewModel.MessageModel]()
    private let newMessagesSubject = BehaviorRelay<[MessageModel]>(value: [])
    var newMessages: Driver<[MessageModel]> { return newMessagesSubject.asDriver(onErrorJustReturn: []) }
    
    private var pollTimer: Timer?
    
    var userDisplayName: String {
        guard let publicUser = UserSession.shared.user?.publicUser else { return String.empty }
        return getDisplayName(user: publicUser)
    }
    func getDisplayName(user: PublicUser) -> String {
        return "\(user.firstName) \(user.lastName)"
    }
    
    var userId: String {
        guard let id = UserSession.shared.user?.publicUser.id else { return String.empty }
        return "\(id)"
    }
    

    func amIBuyer() -> Bool {
        guard let messageBuyer = topLevelMessage.buyerPublicUserId else {
            debugPrint("buyer false")
            return false
        }
        guard let user = UserSession.shared.user?.publicUser.id else {
            debugPrint("user false")
            return false
        }
        return (user == messageBuyer)

    }

    // MARK: - Lifecycle
    init(apiClient: APIClient, topLevelMessage: Message, contactImage: UIImage?, userImage: UIImage?) {
        self.apiClient = apiClient
        self.topLevelMessage = topLevelMessage
        self.contactImage = contactImage
        self.userImage = userImage

        pollConversation(messageCount: historyMessageCount)
        pollTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(pollingInterval), repeats: true, block: { [weak self] (_) in
            guard let `self` = self else { debugPrint("can't find self"); return }
            self.pollConversation(messageCount: self.pollMessageCount)
        })
    }
    
    // MARK: - Private Methods
    private func review(message: Message, action: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let authToken = UserSession.shared.authToken else { return }
        guard let engagementId = message.businessEngagementId else { return }
        apiClient.reviewEngagement(authToken: authToken, businessEngagementId: engagementId, action: action)
            .subscribe(onSuccess: { [weak self] (response) in
                guard let engagement = response.data?.businessEngagement else { completion(false); return }
                //self?.update(engagement: engagement)
                completion(true)
            }) { (_) in
                completion(false)
            }
            .disposed(by: bag)
    }
    func decline(message: Message, completion: @escaping (_ success: Bool) -> Void) {
        review(message: message, action: "decline", completion: completion)
    }
    
    func accept(message: Message, completion: @escaping (_ success: Bool) -> Void) {
        review(message: message, action: "accept", completion: completion)
    }
    
    func withdraw(message: Message, completion: @escaping (_ success: Bool) -> Void) {
        review(message: message, action: "withdraw", completion: completion)
    }
    
    // MARK: - Private Methods
    func pollConversation(messageCount: Int) {
        debugPrint("POLLING")

        guard let authToken = UserSession.shared.authToken else { return }
        debugPrint("auth ok")

        guard let engagementId = topLevelMessage.businessEngagementId else { return }

        apiClient.listMessagesByEngagement(authToken: authToken,
                                           engagementId: engagementId,
                                           perPage: messageCount,
                                           page: nil)
            .subscribe(onSuccess: { [weak self] (response) in
                guard let `self` = self else { return }
                guard let messages = response.data?.messages else { return }
                let models = self.removeDuplicates(from: self.models(for: messages))
                self.messages.append(contentsOf: models)
                self.newMessagesSubject.accept(models)
            })
            .disposed(by: bag)
    }
    
    private func models(for messages: [Message]) -> [MessageModel] {
        var models = [MessageModel]()
        messages.forEach { (message) in
            let contact = message.fromPublicUser
            
            guard let senderId = contact?.id else { return }
            guard let messageId = message.id else { return }
            guard let date = message.timestamp?.timestampToDate() else { return }
            //get not me
            
            let contactUsername = getDisplayName(user: contact!)
            var messageKind = MessageKind.text(message.content ?? String.empty)
            var messageSubType = ChatMessageSubtype.message()

            if message.type == "Access" {
                //messageKind = MessageKind.custom(message.content)
                messageKind = MessageKind.custom(message)
                messageSubType = ChatMessageSubtype.accessBusinessEngagement(message.businessEngagementId!)
                debugPrint("ADD BUTTONS HERE")
                //Add buttons for access
            }
        
            let model = MessageModel(sender: Sender(id: "\(senderId)",
                                                    displayName: contactUsername),
                                     messageId: "\(messageId)",
                                     sentDate: date,
                                     kind: messageKind,
                                     subType: messageSubType)
            models.append(model)
        }
        return models
    }
    
    private func removeDuplicates(from models: [MessageModel]) -> [MessageModel] {
        let messageIds = messages.map { $0.messageId }
        return models.filter { (model) -> Bool in
            return !messageIds.contains(where: { (id) -> Bool in
                return id == model.messageId
            })
        }
    }
    
    // MARK: - Public Methods
    func postMessage(text: String) {
        guard let authToken = UserSession.shared.authToken else { return }
        guard let engagementId = topLevelMessage.businessEngagementId else { return }
        apiClient.createMessage(authToken: authToken, engagementId: engagementId, content: text)
            .subscribe(onSuccess: { [weak self] (response) in
                guard let `self` = self else { return }
                guard let message = response.data?.message else { return }
                guard let model = self.models(for: [message]).first else { return }
                self.messages.append(model)
                self.newMessagesSubject.accept([model])
            })
            .disposed(by: bag)
    }
    
    func stopPolling() {
        pollTimer?.invalidate()
    }
    
    
}

// MARK: - Messages Data Source
extension ConversationViewModel: MessagesDataSource {
    func getApiClient() -> APIClient {
        return apiClient
    }
    func currentSender() -> Sender {
        return Sender(id: userId, displayName: userDisplayName)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}
