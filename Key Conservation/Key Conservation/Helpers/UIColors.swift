//
//  UIColors.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/25/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func getGreenColor() -> UIColor {
        return UIColor(red:0.38, green:0.91, blue:0.53, alpha:1.0)
    }
    
    class func getGreenDisabledColor() -> UIColor {
        return UIColor(red:0.38, green:0.91, blue:0.53, alpha:0.25)
    }
    
    class func getBlueColor() -> UIColor {
        return UIColor(red:0.00, green:0.31, blue:1.00, alpha:1.0)
    }
    
    class func getCritEndangeredColor() -> UIColor {
        return UIColor(red:0.95, green:0.23, blue:0.18, alpha:1.0)
    }
    
    class func getEndangeredColor() -> UIColor {
        return UIColor(red:0.93, green:0.38, blue:0.33, alpha:1.0)
    }
    
    class func getVulnerableColor() -> UIColor {
        return UIColor(red:0.93, green:0.51, blue:0.33, alpha:1.0)
    }
    
    class func getNearThreatenedColor() -> UIColor {
        return UIColor(red:0.43, green:0.64, blue:0.30, alpha:1.0)
    }
   
}
