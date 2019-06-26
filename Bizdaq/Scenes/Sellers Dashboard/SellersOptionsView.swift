//
//  SellersOptionsView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 06/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

protocol SellersOptionsViewDelegate {
    func sellersOptionsView(_ view: SellersOptionsView, didPressButton atIndex: Int)
}

class SellersOptionsView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    fileprivate let cellWidth: CGFloat = 137.0
    var delegate: SellersOptionsViewDelegate?
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
        style()
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "OptionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "optionCell")
    }
    
    // MARK: - Private Methods
    private func style() {
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension SellersOptionsView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionCell", for: indexPath) as? OptionCell else { return UICollectionViewCell() }
        cell.setHandler { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.sellersOptionsView(self, didPressButton: indexPath.row)
        }
        
        if indexPath.row == 0 {
            cell.imageView.image = Theme.SellersDashboard.createAdvertIcon
            cell.label.text = Lexicon.SellersDashboard.createAdvertTitle
        } else if indexPath.row == 1 {
            cell.imageView.image = Theme.SellersDashboard.messagesIcon
            cell.label.text = Lexicon.SellersDashboard.messagesTitle
        }else if indexPath.row == 2 {
            cell.imageView.image = Theme.SellersDashboard.keyInfoIcon
            cell.label.text = Lexicon.Documents.documents
        }
        
//        else if indexPath.row == 2 {
//            cell.imageView.image = Theme.SellersDashboard.keyInfoIcon
//            cell.label.text = Lexicon.SellersDashboard.keyInfoTitle
//        } else if indexPath.row == 3 {
//            cell.imageView.image = Theme.SellersDashboard.offersIcon
//            cell.label.text = Lexicon.SellersDashboard.offersTitle
//        } else if indexPath.row == 4 {
//            cell.imageView.image = Theme.SellersDashboard.upsellsIcon
//            cell.label.text = Lexicon.SellersDashboard.upsells
//        }
        
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
extension SellersOptionsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: frame.height)
    }
}
