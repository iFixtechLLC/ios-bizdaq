//
//  AccessView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

protocol AccessViewDelegate: class {
    func accessViewDidPressMessageButton(state: AccessView.AccessState)
    func accessViewDidPressCancelButton()
    func accessViewDidPressCreateViewingButton()
    func accessViewDidPressKeyInfoButton()
    func accessViewDidPressMakeOfferButton()
}

class AccessView: UIView {
    
    // MARK: - Properties
    weak var delegate: AccessViewDelegate?
    
    enum AccessState {
        case noAccess
        case requestedAccess
        case grantedAccess
        
        static func accessStateForEngagement(_ engagement: BusinessEngagement) -> AccessView.AccessState {
            if engagement.isFullDetailsAccessible ?? false {
                return .grantedAccess
            } else if engagement.isFullDetailsRequested ?? false {
                return .requestedAccess
            } else {
                return .noAccess
            }
        }
    }
    var accessState: AccessState = .noAccess {
        didSet {
            render(accessState)
        }
    }
    private weak var view: UIView?
    private let animationDuration: CGFloat = 0.35
    
    // MARK: - Private Methods
    private func render(_ state: AccessState) {
        view?.removeFromSuperview()
        
        switch state {
        case .noAccess:
            let view = NoAccessView { [weak self] in self?.delegate?.accessViewDidPressMessageButton(state: .noAccess) }
            switchView(to: view)
        case .requestedAccess:
            let view = RequestAccessView(messageButtonHandler: { [weak self] in
                    self?.delegate?.accessViewDidPressMessageButton(state: .requestedAccess)
                }) { [weak self] in
                    self?.delegate?.accessViewDidPressCancelButton()
                }
            switchView(to: view)
        case .grantedAccess:
            let view = GrantedAccessView(messageButtonHandler: { [weak self] in
                    self?.delegate?.accessViewDidPressMessageButton(state: .grantedAccess)
                }, createViewingButtonHandler: { [weak self] in
                    self?.delegate?.accessViewDidPressCreateViewingButton()
                }, keyInfoButtonHandler: { [weak self] in
                    self?.delegate?.accessViewDidPressKeyInfoButton()
                }, makeOfferButtonHandler: { [weak self] in
                    self?.delegate?.accessViewDidPressMakeOfferButton()
                })
            switchView(to: view)
        }
    }
    
    private func switchView(to view: UIView) {
        self.view?.removeFromSuperview()
        self.addSubview(view)
        self.view = view
        view.constrainEdges(to: self)
        layoutIfNeeded()
    }
}
