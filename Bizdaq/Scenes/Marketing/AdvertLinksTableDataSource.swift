//
//  AdvertLinksTableDataSource.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class AdvertLinksTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    let cellIdentifier: String
    var links = [String]()
    
    // MARK: - Lifecycle
    init(cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AdvertLinkCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = links[indexPath.row]
        if links.count == 1 { cell.setState(.standalone); return cell }
        switch indexPath.row {
        case 0:
            cell.setState(.top)
        case links.count - 1:
            cell.setState(.bottom)
        default:
            print(indexPath.row)
            cell.setState(.standard)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdvertLinkCell.cellHeight
    }
}
