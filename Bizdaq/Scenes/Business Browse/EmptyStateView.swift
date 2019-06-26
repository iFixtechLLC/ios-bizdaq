//
//  EmptyStateView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    
    // MARK: - Outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    // MARK: - Properties
    private var tryAgainHandler: (() -> Void)?
    
    var isActive = false {
        didSet {
            isHidden = !isActive
            isUserInteractionEnabled = isActive
        }
    }
    
    var title: String? {
        didSet {
            guard let title = title else { return }
            titleLabel.text = title
        }
    }
    
    var isButtonHidden = false {
        didSet {
            tryAgainButton.isHidden = isButtonHidden
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    convenience init(frame: CGRect, tryAgainHandler: (() -> Void)?) {
        self.init(frame: frame)
        self.tryAgainHandler = tryAgainHandler
    }
    
    // MARK: - Public Methods
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func setTryAgainButtonHandler(_ handler: @escaping () -> Void) {
        tryAgainHandler = handler
    }
    
    // MARK: - Actions
    @IBAction func didPressTryAgainButton(_ sender: UIButton) {
        tryAgainHandler?()
    }
}

// MARK: - View States
extension EmptyStateView {
    
    func showConnectionEmptyState(tryAgainHandler: @escaping () -> Void) {
        isActive = true
        isButtonHidden = false
        title = Lexicon.EmptyState.noConnection
        if let image = Theme.Icons.connectionErrorImage {
            setImage(image)
        }
        setTryAgainButtonHandler(tryAgainHandler)
    }
    
    func showNoResultsEmptyState() {
        isActive = true
        isButtonHidden = true
        title = Lexicon.EmptyState.noResults
        if let image = Theme.Icons.genericErrorImage {
            setImage(image)
        }
    }
    
    func showNoFavouritesEmptyState() {
        isActive = true
        isButtonHidden = true
        if UserSession.shared.authToken == nil {
            title = Lexicon.Error.LoginToUseFavourites
        } else {
            title = Lexicon.EmptyState.noFavourites
        }
        if let image = Theme.Icons.genericErrorImage {
            setImage(image)
        }
    }
    
    func hideAllEmptyStates() {
        isActive = false
    }
}
