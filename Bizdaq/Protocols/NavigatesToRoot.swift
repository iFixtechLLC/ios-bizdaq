//
//  NavigatesToRoot.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

protocol NavigatesToRoot { }

extension NavigatesToRoot where Self: UIViewController {
    
    func navigateToRoot(animated: Bool) {
        guard let navController = navigationController else { return }
        if let root = navController.viewControllers.first {
            debugPrint("🚕 NAVIGATE (ROOT): \(self.classForCoder) -> \(root.classForCoder)")
        }
        navController.popToRootViewController(animated: animated)
    }
}
