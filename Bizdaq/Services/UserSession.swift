//
//  UserSession.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 16/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation

class UserSession {
    
    // MARK: - Properties
    static let shared = UserSession()
    
    var user: User?
    
    var isLoggedIn: Bool { return user != nil }
    var authToken: AuthToken? { return user?.token }
    
    // MARK: - Singleton Lifecycle
    private init() {}
    
    // MARK: - Public Methods
    func setActiveUser(_ user: User) {
        printLogin(user: user)
        self.user = user
    }
    
    func invalidate() {
        if user != nil {
            printLogout(user: user!)
            user = nil
        }
    }
    
    // MARK: - Private Methods
    private func printLogin(user: User) {
        debugPrint("👨‍💻 USER SESSION -> LOGGED IN ([\(user.publicUser.id)] \(user.publicUser.firstName) \(user.publicUser.lastName) : 🔑 \(user.token))")
    }
    
    private func printLogout(user: User) {
        debugPrint("👨‍💻 USER SESSION -> LOGGED OUT ([\(user.publicUser.id)] \(user.publicUser.firstName) \(user.publicUser.lastName))")
    }
}
