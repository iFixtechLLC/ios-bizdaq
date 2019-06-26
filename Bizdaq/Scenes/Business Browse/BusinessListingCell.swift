//
//  BusinessListingCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 19/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//


import UIKit
import MapKit
import RxSwift
import RxCocoa

class BusinessListingCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var askingPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var leaseholdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var turnoverLabel: UILabel!
    @IBOutlet weak var addedLabel: UILabel!
    @IBOutlet weak var recommendedView: UIView!
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    @IBOutlet var animatedConstraints: [NSLayoutConstraint]!

    // MARK: - Properties
    private let bag = DisposeBag()
    private(set) var business: Business?
    private var handler: ((_ isFavourited: Bool) -> Void)?
    private(set) var isFavourited = false
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        heroImageView.image = UIImage()
    }
    
    override func didMoveToSuperview() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        recommendedView.style(rounded: true)
    }
    
    // MARK: - Public Methods
    func configure(for business: Business) {
        self.business = business
        
        if let pathToPrimaryPhotoFile = business.businessPhotos?.first?.pathToFile {
            ImageCache.setImage(for: heroImageView, pathToFile: pathToPrimaryPhotoFile, temporaryImage: UIImage(named: Constants.placeholderImageName))
        } else {
            heroImageView.image = UIImage(named: Constants.placeholderImageName)
        }
        
        if let premiumListing = business.isPremiumListing {
            recommendedView.isHidden = premiumListing ? false : true
        }
        
        favouriteImageView.isHidden = !UserSession.shared.isLoggedIn
        if let isFavourited = business.isSaved {
            self.isFavourited = isFavourited
            favouriteImageView.image = isFavourited
                ? Theme.Icons.activeFavouriteIcon
                : Theme.Icons.inactiveFavouriteIcon
        }
        
        askingPriceLabel.text = business.askingPrice != nil ? "\(business.askingPrice!.toCurrency())" : "N/A"
        setDistance()
        leaseholdLabel.text = business.tenure ?? "N/A"
        nameLabel.text = business.advertHeadline ?? "N/A"
        locationLabel.text = business.businessLocation?.name ?? "N/A"
        turnoverLabel.text = business.annualTurnover != nil ? "\(business.annualTurnover!.toCurrency()) turnover" : "N/A"
        addedLabel.text = "N/A"
    }
    
    func setFavourited(state: Bool) {
        isFavourited = state
        favouriteImageView.image = state
            ? Theme.Icons.activeFavouriteIcon
            : Theme.Icons.inactiveFavouriteIcon
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.animatedConstraints.forEach({ (constraint) in
                constraint.constant += 5
                self?.layoutIfNeeded()
            })
        }) { [weak self] (_) in
            self?.favouriteImageView.image = state
                ? Theme.Icons.activeFavouriteIcon
                : Theme.Icons.inactiveFavouriteIcon
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.animatedConstraints.forEach({ (constraint) in
                    constraint.constant -= 5
                    self?.layoutIfNeeded()
                })
            })
        }
    }
    
    func setFavouriteButtonHandler(_ handler: @escaping (_ isFavourited: Bool) -> Void) {
        self.handler = handler
    }
    
    // MARK - Actions
    @IBAction func didPressFavouriteButton(_ sender: UIButton) {
        //setFavourited(state: isFavourited)
        handler?(isFavourited)
    }
    
    func setDistance(){
        distanceLabel.text = "N/A"
        let locManager = CLLocationManager()
        
        var currentLocation: CLLocation!
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            currentLocation = locManager.location
            guard let address = business!.address?.postcode else { return }
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let placemarks = placemarks {
                    if placemarks.count != 0 {
                        guard let coordinates = placemarks.first?.location?.coordinate else { return }
                        let clLocation = CLLocation(latitude: coordinates.latitude,
                                                    longitude: coordinates.longitude)
                        clLocation.distance(from: currentLocation)
                        let meters = clLocation.distance(from: currentLocation)
                        
                        let miles = meters/1609.344
                        
                        let roundedMiles = round(Float(miles * 100)) / 100
                        print(roundedMiles) //5.68
                        self.distanceLabel.text = String(describing: roundedMiles)
                    }
                }
            }
        }
        
        
        
    }
    
}
