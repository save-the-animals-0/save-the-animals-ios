//
//  NumberFormatter.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/26/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation

extension Double {
    var clean: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self)) ?? "$0"
    }
}
