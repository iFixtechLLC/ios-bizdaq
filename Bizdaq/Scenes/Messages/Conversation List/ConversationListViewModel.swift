//
//  ConversationListViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 27/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ConversationListViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient?
    private var messages: [Message]?
    
    private let messagesSubject = BehaviorSubject<[Message]?>(value: nil)
    var messagesDriver: Driver<[Message]?> { return messagesSubject.asDriver(onErrorJustReturn: nil) }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        updateConversations()
    }
    
    // MARK: - Private Methods
    private func updateConversations() {
        guard let authToken = UserSession.shared.authToken else { return }
        apiClient?.listTopLevelMessages(authToken: authToken, photoWidth: 50, photoHeight: 50)
            .subscribe(onSuccess: { [weak self] (response) in
                
                var m = Array<Message>()
                response.data?.topLevelMessages?.forEach{ m.append($0) }
                //guard let messages = response.data?.topLevelMessages?.values else { return }
                self?.messages = m
                self?.messagesSubject.onNext(m)
            }, onError: { [weak self] (error) in
                self?.messages = nil
                self?.messagesSubject.onNext(nil)
            })
            .disposed(by: bag)
    }
    
    private func markAsRead(messageId: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "\(messageId)")
    }
    
    // MARK: - Public Methods
    func filter(by string: String) {
        if string.count <= 0 {
            messagesSubject.onNext(messages)
        } else {
            let filteredMessages = messages?.filter({ (message) -> Bool in
                var sender = message.fromPublicUser
                if(message.fromPublicUser?.id == UserSession.shared.user?.publicUser.id){
                    sender = message.toPublicUser
                }
                let firstname = sender?.firstName ?? String.empty
                let lastname = sender?.lastName ?? String.empty
                let name = "\(firstname) \(lastname)"
                return name.range(of: string, options: .caseInsensitive) != nil
            })
            messagesSubject.onNext(filteredMessages)
        }
    }
    
    func isMessageRead(messageId: Int) -> Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: "\(messageId)")
    }
}
