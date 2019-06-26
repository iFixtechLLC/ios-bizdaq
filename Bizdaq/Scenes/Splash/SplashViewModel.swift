//
//  SplashViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

struct SplashViewModel {
    
    // MARK: - Properties
    let delaySubject: BehaviorSubject<TimeInterval>
    private var timer: Timer?
    
    // MARK: - Lifecycle
    init(delay: TimeInterval) {
        delaySubject = BehaviorSubject<TimeInterval>(value: delay)
    }
    
    // MARK: - Public Methods
    func updateDynamicLexicon(completion: @escaping (_ success: Bool) -> ()) {
        DynamicLexicon.update { (success) in
            completion(success)
        }
    }
    
    mutating func delay(for seconds: TimeInterval, completion: @escaping () -> ()) {
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { (timer) in
            timer.invalidate()
            completion()
        })
    }
}
