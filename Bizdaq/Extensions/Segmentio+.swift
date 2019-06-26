//
//  Segmentio+.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import Segmentio

extension Segmentio {
    func setupWithTitles(_ titles: [String]) {
        var items = [SegmentioItem]()
        titles.forEach { (title) in
            items.append(SegmentioItem(title: title, image: nil))
        }
        
        let unselectedTextColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        let states = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "Helvetica", size: 15) ?? UIFont.systemFont(ofSize: 15),
                titleTextColor: unselectedTextColor
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "Helvetica", size: 15) ?? UIFont.systemFont(ofSize: 15),
                titleTextColor: .white
            ),
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "Helvetica", size: 15) ?? UIFont.systemFont(ofSize: 15),
                titleTextColor: .white
            )
        )
        
        let indicatorColor = UIColor(red: 2.0/255.0, green: 60.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        let indicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 3.0, color: indicatorColor)
        let horizontalSeperatorOptions = SegmentioHorizontalSeparatorOptions(
            type: SegmentioHorizontalSeparatorType.none,
            height: 0,
            color: .white)
        let verticalSeperatorOptions = SegmentioVerticalSeparatorOptions(ratio: 0, color: UIColor.white)
        let options = SegmentioOptions(
            backgroundColor: UIColor(named: "bizdaq-blue") ?? .white,
            segmentPosition: .fixed(maxVisibleItems: 2),
            scrollEnabled: false,
            indicatorOptions: indicatorOptions,
            horizontalSeparatorOptions: horizontalSeperatorOptions,
            verticalSeparatorOptions: verticalSeperatorOptions,
            imageContentMode: .bottom,
            labelTextAlignment: .center,
            segmentStates: states)
        
        setup(content: items, style: SegmentioStyle.onlyLabel, options: options)
    }
}
