//
//  CalendarDayCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 24/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDayCell: JTAppleCell {
    
    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var highlightedView: UIView!
    
    // MARK: - Properties
    static let id = "CalendarDayCell"
    
    let defaultTextColor = UIColor(hex: "4A4A4A")
    let selectedTextColor = UIColor.white
    let hiddenTextColor = UIColor.white
    
    var isHighlightedDate: Bool = false {
        didSet {
            if isHighlightedDate {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.highlightedView.alpha = 1.0
                }
            } else {
                self.highlightedView.alpha = 0.0
            }
            dateLabel.textColor = isHighlightedDate ? selectedTextColor : defaultTextColor
        }
    }
}
