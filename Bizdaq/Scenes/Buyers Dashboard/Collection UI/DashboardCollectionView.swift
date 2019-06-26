//
//  HorizontalCollection.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 06/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

protocol DashboardCollectionViewDelegate {
    func dashboardCollectionView(_ collectionView: DashboardCollectionView, didSelect business: Business)
    func dashboardCollectionView(_ collectionView: DashboardCollectionView, distanceFromContentEnd: CGFloat, contentWidth: CGFloat)
}

class DashboardCollectionView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var businesses = [Business]()
    var delegate: DashboardCollectionViewDelegate?
    
    private let progressHUD = JGProgressHUD(style: .dark)
    
    private let emptyStateCellCount = 2
    var emptyMessage: String?
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        registerCells()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "DashboardCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "dashboardCollectionCell")
        collectionView.register(UINib(nibName: "DashboardCollectionEmptyCell", bundle: Bundle.main), forCellWithReuseIdentifier: "dashboardCollectionEmptyCell")
    }
    
    // MARK: - Public Methods
    func setContentStream(_ driver: Driver<[Business]>) {
        progressHUD.parallaxMode = .alwaysOff
        progressHUD.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        progressHUD.show(in: self, animated: true)
        businesses.removeAll()
        driver.drive(onNext: { [weak self] (businesses) in
            self?.businesses = businesses
            self?.collectionView.reloadData()
            self?.progressHUD.dismiss(afterDelay: 1.0, animated: true)
        })
        .disposed(by: bag)
    }
}


// MARK: - Collection View Delegate & Data Source
extension DashboardCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !businesses.isEmpty ? businesses.count : emptyStateCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !businesses.isEmpty {
            collectionView.isScrollEnabled = true
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCollectionCell", for: indexPath) as? DashboardCollectionCell else { return UICollectionViewCell() }
            cell.isUserInteractionEnabled = true
            cell.configure(for: businesses[indexPath.row])
            return cell
        } else {
            collectionView.isScrollEnabled = false
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCollectionEmptyCell", for: indexPath) as? DashboardCollectionEmptyCell else { return UICollectionViewCell() }
            cell.emptyMessage = emptyMessage ?? String.empty
            cell.isUserInteractionEnabled = false
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.dashboardCollectionView(self, didSelect: businesses[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.dashboardCollectionView(self,
                                          distanceFromContentEnd: scrollView.contentSize.width - scrollView.contentOffset.x,
                                          contentWidth: scrollView.contentSize.width)
    }
}

// MARK: - UICollectionView Layout Delegate
extension DashboardCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DashboardCollectionCell.cellWidth, height: frame.height)
    }
}
