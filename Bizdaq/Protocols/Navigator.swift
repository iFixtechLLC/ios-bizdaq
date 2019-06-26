//
//  Navigator.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

protocol Navigator {
    associatedtype DestinationIdentifier: RawRepresentable
}

extension Navigator where Self: UIViewController, DestinationIdentifier.RawValue == String {
    
    func navigate(to destination: DestinationIdentifier, sender: Any?) {
        performSegue(withIdentifier: destination.rawValue, sender: sender)
    }
    
    func destinationIdentifier(for segueIdentifier: String) -> DestinationIdentifier {
        guard let destinationIdentifier = DestinationIdentifier(rawValue: segueIdentifier) else {
            fatalError("Invalid segue `\(segueIdentifier)`.")
        }
        return destinationIdentifier
    }
    
    func destinationIdentifier(for segue: UIStoryboardSegue) -> DestinationIdentifier {
        guard let segueIdentifier = segue.identifier else {
            fatalError("Segue has empty identifier.")
        }
        return destinationIdentifier(for: segueIdentifier)
    }
}
