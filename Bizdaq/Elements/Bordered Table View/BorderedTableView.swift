//
//  StatisticTableView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 12/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class BorderedTableView: UIView {
    
    // MARK: - Properties
    private var tableView: UITableView?
    private var keys = [String]()
    private var values = [String]()
    
    var valuesHidden = false {
        didSet {
            tableView?.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addTableView()
        registerCells()
    }

    private func addTableView() {
        tableView = UITableView(frame: frame)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.separatorStyle = .none
        tableView!.isScrollEnabled = false
        addSubview(tableView!)
        tableView?.constrainEdges(to: self)
    }
    
    convenience init(keys: [String], values: [String]) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: BorderedTableCell.cellHeight * CGFloat(keys.count)).isActive = true
        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width).isActive = true
        
        self.keys = keys
        self.values = values
        guard keys.count == values.count else { preconditionFailure("Mismatch between size of keys and values arrays.") }
        self.tableView?.reloadData()
    }
    
    private func registerCells() {
        tableView?.register(UINib(nibName: "BorderedTableCell", bundle: Bundle.main), forCellReuseIdentifier: "borderedTableCell")
    }
}

// MARK: - TableView Data Source & Delegate
extension BorderedTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "borderedTableCell", for: indexPath) as? BorderedTableCell else {
            return UITableViewCell()
        }
        
        cell.keyLabel.text = keys[indexPath.row]
        cell.valueLabel.text = values[indexPath.row]
        cell.setValueHidden(valuesHidden)
        
        if indexPath.row == 0 {
            cell.setState(.top)
        } else if indexPath.row == keys.count - 1 {
            cell.setState(.bottom)
        } else {
            cell.setState(.standard)
        }
        
        return cell
    }
}
