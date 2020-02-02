//
//  UIViewController+Extension.swift
//  MapAnnotatation
//
//  Created by sysadmin on 01/02/20.
//  Copyright © 2020 Ramkrishna Sharma. All rights reserved.
//

import UIKit

extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
}
