//
//  MapCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public Methods
    func configure(with business: Business) {
        guard let address = business.address?.postcode else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let annotation = MKPlacemark(placemark: placemarks.first!)
                    self?.mapView.addAnnotation(annotation)
                    
                    guard let coordinates = placemarks.first?.location?.coordinate else { return }
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinates.latitude,
                                                                                   longitude: coordinates.longitude), span: span)
                    self?.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
}
