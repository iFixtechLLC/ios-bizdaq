//
//  PropertyTableCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class PropertyTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    enum TableKey {
        static let propertyType = "Property Type"
        static let accomodation = "Accomodation"
        static let staff = "Staff"
        static let netProfit = "Net Profit"
        static let propertyValue = "Property Value"
        static let yearsEstablished = "Years Established"
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public Methods
    func configure(with business: Business) {
        let keys = [TableKey.propertyType,
                    TableKey.accomodation,
                    TableKey.staff,
                    TableKey.netProfit,
                    TableKey.propertyValue,
                    TableKey.yearsEstablished]
        let values = [business.tenure ?? Lexicon.BusinessDetail.noValue,
                      business.propertyHasAccomodation ?? Lexicon.BusinessDetail.noValue,
                      business.hasStaff ?? Lexicon.BusinessDetail.noValue,
                      "\(business.netProfit?.toCurrency() ?? 0.toCurrency())",
                      "\(business.propertyFeeholdValue?.toCurrency() ?? 0.toCurrency())",
                      "\(business.yearBusinessEstablished ?? 0)"]
        let tableView = BorderedTableView(keys: keys, values: values)
        containerView.addSubview(tableView)
        tableView.constrainEdges(to: containerView)
        tableView.valuesHidden = !UserSession.shared.isLoggedIn
    }
}
