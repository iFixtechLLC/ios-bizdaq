//
//  PromosDataSource.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift

class PromosTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    let cellIdentifier: String
    var promoEmails = [PromoEmails]()
    
    // MARK: - Lifecycle
    init(cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promoEmails.count > 0 ? promoEmails.count + 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PromoCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.leftLabel.text = "Date/time"
            cell.rightLabel.text = "Emails sent"
        } else {
            print(indexPath.row)
            cell.leftLabel.text = promoEmails[indexPath.row - 1].dateTimeCreated
            cell.rightLabel.text = promoEmails[indexPath.row - 1].emailsSent
        }
        
        switch indexPath.row {
        case 0:
            cell.setState(.top)
        case promoEmails.count:
            cell.setState(.bottom)
        default:
            print(indexPath.row)
            cell.setState(.standard)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PromoCell.cellHeight
    }
}
