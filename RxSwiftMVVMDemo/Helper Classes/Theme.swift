//  RxSwiftMVVMDemo
//
//  Created by Bhavnish on 31/05/22.
//  Copyright © 2021 Bhavnish Mac. All rights reserved.
//



import Foundation
import UIKit
class Theme: NSObject {
    static let standard = Theme()
    
    enum Colors: String {
        case primaryColor = "#4F172D"
        case secondry = "#936172"
        // black
        case fontBalck = "#000000"
        case gray = "#D4D4D4"
        case lightgray = "#E4E4E4"
        case lightsecondary = "#FAD0C4"
        case purple = "#262262"
        case red = "#E00000"
        case green = "#0DBF00"
        case blue = "#0008FF"
        case white = "#FFFFFF"
        case textpurple = "#0077FF"
        case textOrange = "#FFA800"
        case bgPurpleColor = "#F2EFFF"
        var instance: UIColor {
            return UIColor.init(hex: self.rawValue)
        }
    }
    enum FontSize: Float {
        case nano = 8
        case mini = 10
        case xss = 11
        case macro = 12
        case extraSmall = 13
        case small = 14
        case mediumSize = 15
        case normal = 16
        case large = 17
        case extraLarge = 18
        case xll = 19
        case xxl = 20
        case btnTitlesize = 25
        case headerExtraLarge = 30
    }
    
    enum FontStyle: String {
        case bold = "ProximaNova-Extra-Bold"
        case light = "ProximaNova-Light"
        case regular = "ProximaNova-Regular"
        case medium = "ProximaNova-Bold"
        case systemRegular = "System Font Regular"
    }
   
    
}
