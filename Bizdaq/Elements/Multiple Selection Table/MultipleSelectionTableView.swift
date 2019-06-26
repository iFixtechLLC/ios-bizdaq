//
//  MultipleSelectionTableView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MultipleSelectionTableView: UITableView {
    
    // MARK: - Properties
    private var options: [String]?
    var optionsPressed = Set<Int>()
    
    var contentHeight: CGFloat {
        guard let count = options?.count else { return 0 }
        return CGFloat(count) * 30
    }
    
    // Streams
    private let selectedIndicesSubject = BehaviorSubject<[Int]?>(value: nil)
    var selectedIndicesDriver: Driver<[Int]?> { return selectedIndicesSubject.asDriver(onErrorJustReturn: nil) }
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        registerTableCells()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        dataSource = self
        registerTableCells()
    }
    
    private func registerTableCells() {
        register(UINib(nibName: "MultipleSelectionCell", bundle: Bundle.main), forCellReuseIdentifier: "MultipleSelectionCell")
    }
    
    // MARK: - Public Methods
    func setOptions(_ options: [String]) {
        self.options = options
        reloadData()
    }
    
    // MARK: - Private Methods
    private func format(cell: MultipleSelectionCell, indexPath: IndexPath) {
        guard let options = options else { return }
        cell.tag = indexPath.row
        cell.setTitle(options[indexPath.row])
        cell.interactionHandler { [weak self] (selected, sender) in
            guard let `self` = self else { return }
            if selected {
                self.optionsPressed.insert(sender.tag)
            } else if self.optionsPressed.contains(sender.tag) {
                self.optionsPressed.remove(sender.tag)
            }
            self.selectedIndicesSubject.onNext(Array(self.optionsPressed))
        }
    }
}

// MARK: UITableView Delegate & Data Source
extension MultipleSelectionTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: "MultipleSelectionCell", for: indexPath) as? MultipleSelectionCell else {
            return UITableViewCell()
        }
        format(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
