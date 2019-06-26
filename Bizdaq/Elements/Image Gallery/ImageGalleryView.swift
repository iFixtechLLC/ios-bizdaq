//
//  ImageGalleryView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 25/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

final class ImageGalleryView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var viewModel = ImageGalleryViewModel()
    private var pageControl: UIPageControl!
    
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
    }
    
    // MARK: - Public Methods
    func setImagePaths(_ imagePaths: [String]) {
        viewModel.imagePaths = imagePaths
        addPageController(numberOfPages: imagePaths.count)
        registerCells()
        collectionView.reloadData()
    }
    
    // MARK: - Private Methods
    private func addPageController(numberOfPages: Int) {
        if pageControl == nil {
            pageControl = UIPageControl(frame: CGRect(x: 0, y: frame.height - 20, width: frame.width, height: 20))
            pageControl.pageIndicatorTintColor = Theme.UIElements.pageIndicatorColor
            pageControl.currentPageIndicatorTintColor = Theme.UIElements.selectedPageIndicatorColor
            pageControl.numberOfPages = numberOfPages
            pageControl.currentPage = 0
            addSubview(pageControl)
        }
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "ImageGalleryCell", bundle: Bundle.main), forCellWithReuseIdentifier: "imageGalleryCell")
    }
}

// MARK: - UICollectionView Delegate, DataSource
extension ImageGalleryView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageGalleryCell", for: indexPath) as? ImageGalleryCell else { return UICollectionViewCell() }
        cell.configure(imagePath: viewModel.imagePaths?[indexPath.section] ?? "")
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.imagePaths?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollToNearestVisibleCollectionViewCell() {
        collectionView.decelerationRate = 0.0
        let offset = collectionView.contentOffset
        var cellNumber = Int((offset.x + frame.width / 2) / frame.width)
        if cellNumber < 0 { cellNumber = 0 }
        let indexPath = IndexPath(row: 0, section: cellNumber)
        pageControl.currentPage = cellNumber
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionView Layout Delegate
extension ImageGalleryView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
}
