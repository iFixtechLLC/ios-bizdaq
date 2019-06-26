//
//  CalendarCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 25/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import JTAppleCalendar
import RxSwift
import RxCocoa

class CalendarCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var calendar: JTAppleCalendarView!
    
    // MARK: - Properties
    static let id = "CalendarCell"
    
    private let bag = DisposeBag()
    private var viewingDates = [Date]()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCalendarView()
        registerCells()
    }
    
    private func setupCalendarView() {
        calendar.minimumLineSpacing = 0
        calendar.minimumInteritemSpacing = 0
    }
    
    private func registerCells() {
        calendar.register(UINib(nibName: CalendarDayCell.id, bundle: nil), forCellWithReuseIdentifier: CalendarDayCell.id)
    }
    
    // MARK: - Public Methods
    func setDates(driver: Driver<[Date?]>) {
        driver.drive(onNext: { [weak self] (dates) in
            self?.viewingDates = dates.filter { $0 != nil } .map { $0! }
            self?.calendar.reloadData()
        })
        .disposed(by: bag)
    }
}

// MARK: - JTAppleCalendar Delegate & Data Source
extension CalendarCell: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date()
        let endDate = Date(timeIntervalSinceNow: TimeInterval(31536000))
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarDayCell.id, for: indexPath) as! CalendarDayCell
        cell.dateLabel.text = cellState.text
        let isHighlighted = viewingDates.contains(where: { Calendar.current.isDate(date, inSameDayAs: $0) } )
        cell.isHighlightedDate = isHighlighted
        if !isHighlighted {
            cell.dateLabel.textColor = cellState.dateBelongsTo == .thisMonth ? cell.defaultTextColor : cell.hiddenTextColor
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
}

