//
//  Double+Extension.swift
//  MapAnnotatation
//
//  Created by sysadmin on 02/02/20.
//  Copyright © 2020 Ramkrishna Sharma. All rights reserved.
//

import UIKit

extension Double {
    
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
