//
//  GrantedAccessView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class GrantedAccessView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    static let viewHeight: CGFloat = 208.0
    
    private var messageButtonHandler: (() -> Void)?
    private var createViewingButtonHandler: (() -> Void)?
    private var keyInfoButtonHandler: (() -> Void)?
    private var makeOfferButtonHandler: (() -> Void)?
    
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        xibSetup()
        style()
        registerCells()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    convenience init(messageButtonHandler: @escaping () -> Void,
                     createViewingButtonHandler: @escaping () -> Void,
                     keyInfoButtonHandler: @escaping () -> Void,
                     makeOfferButtonHandler: @escaping () -> Void) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: NoAccessView.viewHeight))
        self.messageButtonHandler = messageButtonHandler
        self.createViewingButtonHandler = createViewingButtonHandler
        self.keyInfoButtonHandler = keyInfoButtonHandler
        self.makeOfferButtonHandler = makeOfferButtonHandler
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "OptionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "optionCell")
    }
    
    // MARK: - Styling
    private func style() {
        messageButton.style(rounded: true)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    // MARK: - Actions
    @IBAction func didPressMessageButton(_ sender: UIButton) {
        messageButtonHandler?()
    }
}

// MARK: - Collection View Delegate
extension GrantedAccessView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionCell", for: indexPath) as? OptionCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.imageView.image = Theme.Icons.arrangeViewingIcon
            cell.label.text = Lexicon.BusinessDetail.arrangeViewing
            cell.setHandler {
                self.createViewingButtonHandler?()
            }
        } else if indexPath.row == 1 {
            cell.imageView.image = Theme.Icons.makeOfferIcon
            cell.label.text = Lexicon.BusinessDetail.makeAnOffer
            cell.setHandler {
                self.makeOfferButtonHandler?()
            }
        } else if indexPath.row == 2 {
            cell.imageView.image = Theme.Icons.keyInfoIcon
            cell.label.text = Lexicon.Documents.documents
            cell.setHandler {
                self.keyInfoButtonHandler?()
            }
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
}

// MARK: - UICollectionView Layout Delegate
extension GrantedAccessView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: OptionCell.viewWidth, height: OptionCell.viewHeight)
    }
}
