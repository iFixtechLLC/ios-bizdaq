//
//  ConversationListViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 28/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift

class ConversationListViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: ValidatedTextField!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: ConversationListViewModel?
    private var messages: [Message]?
    private var selectedMessage: Message?
    private var contactImage: UIImage?
    
    // MARK: - Lifecycle
    func attach(to viewModel: ConversationListViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { return }
        searchTextField.setPlaceholder(Lexicon.Messages.searchPlaceholder)
        registerCells()
        bind(to: viewModel)
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "ConversationCell", bundle: Bundle.main), forCellReuseIdentifier: "conversationCell")
    }
    
    // MARK: - Binding
    func bind(to viewModel: ConversationListViewModel) {
        viewModel.messagesDriver
            .drive(onNext: { [weak self] (messages) in
                self?.messages = messages
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
        
        searchTextField.valueDriver
            .drive(onNext: { (value) in
                guard value != nil else { return }
                viewModel.filter(by: value!)
            })
            .disposed(by: bag)
        searchTextField.clearButton.addTarget(self, action: #selector(didPressClearSearch), for: .touchUpInside)
    }
    @objc func didPressClearSearch(){
        viewModel?.filter(by: "")
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Delegate & Data Source
extension ConversationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as? ConversationCell else { return UITableViewCell() }
        if let model = messages?[indexPath.row] {
            cell.attach(to: model)
            guard let messageId = model.id else { return cell }
            guard let isRead = viewModel?.isMessageRead(messageId: messageId) else { return cell }
            cell.setAsRead(isRead)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ConversationCell else { return }
        contactImage = cell.profileImageView.image
        selectedMessage = messages?[indexPath.row]
        navigate(to: .messages, sender: self)
    }
}

// MARK: - Navigation
extension ConversationListViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case messages
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .messages:
            guard let topLevelMessage = selectedMessage else { preconditionFailure() }
            guard let destination = segue.destination as? ConversationViewController else { preconditionFailure() }
            var myPic:UIImage? = nil
            if ((UserSession.shared.user?.publicUser.publicUserProfile?.photoPathToFile) != nil) {
                myPic = ImageCache.getUIImageFromPath(path: (UserSession.shared.user?.publicUser.publicUserProfile?.photoPathToFile)!, defaultUIImage: Theme.Icons.avatarPlaceholderIcon!)
            }
            
            destination.becomeFirstResponder()
            
            destination.attach(to: ViewModelFactory.Messages.makeConversationModel(topLevelMessage: topLevelMessage, contactImage: contactImage, userImage: myPic))
        }
    }
}
