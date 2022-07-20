//
//  Toast.swift
//  RxSwiftMVVMDemo
//
//  Created by Bhavnish on 31/05/22.
//  Copyright © 2021 Bhavnish Mac. All rights reserved.
//

import UIKit
import SwiftEntryKit

enum AlertType: String {
    case success = "SUCCESS"
    case apiFailure = "API_FAILURE"
    case validationFailure = "VALIDATION_FAILURE"
    var title: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    var color: UIColor {
        switch self {
        case .validationFailure:
            return #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        case .apiFailure:
            return #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        case .success:
            return #colorLiteral(red: 0.0136911124, green: 0.4385278523, blue: 0.9216069579, alpha: 1)
        }
    }
}



enum ToastStyle{
    case simple
    case notificationBanner
}

class Toast {
    
    static let shared = Toast()
    
    func showAlert(type: AlertType, message: String,showimage:Bool = true,style:ToastStyle = ToastStyle.simple) {
        var attributes = EKAttributes()
        attributes.windowLevel = .alerts
        attributes.position = .top
        attributes.displayDuration = 2.0
        attributes.entryInteraction = .dismiss //click on enrty
        attributes.screenInteraction = .dismiss //dismiss by outside click
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.2, radius: 8, offset: .zero)) // add shadow
        var image:EKProperty.ImageContent? //image
              
        switch type{
        case AlertType.success:
            attributes.entryBackground = .color(color: EKColor(AlertType.success.color))
            image = EKProperty.ImageContent(image: #imageLiteral(resourceName: "check-mark"), size: CGSize(width: 30, height: 30))
        case AlertType.apiFailure,AlertType.validationFailure:
            attributes.entryBackground = .color(color: EKColor(AlertType.apiFailure.color))
            image = EKProperty.ImageContent(image: #imageLiteral(resourceName: "error"), size: CGSize(width: 30, height: 30))
            
        }
       // attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(.init(red: 237/255, green: 34/255, blue: 129/255, alpha: 1)), EKColor(.init(red: 72/255, green: 166/255, blue: 68/255, alpha: 1))], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1))) //gradient
        
        switch style {
        case .simple:
            attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
            break
        case .notificationBanner:
            attributes.roundCorners = .all(radius: 8) //round corner
            attributes.positionConstraints.verticalOffset = 10
            attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
            let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.9)
            let heightConstraint = EKAttributes.PositionConstraints.Edge.intrinsic
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
            break
        }
        
        
        let title = EKProperty.LabelContent.init(text: type == .success ? "MTH" : "Error", style: .init(font: UIFont.systemFont(ofSize: 18, weight: .bold), color: .white))
        let description = EKProperty.LabelContent.init(text: message, style: .init(font: UIFont.systemFont(ofSize: 14, weight: .medium), color: .white))
        
        var simpleMessage = EKSimpleMessage.init(title: title, description: description)
        if showimage{
            simpleMessage = EKSimpleMessage.init(image: image, title: title, description: description)
        }else{
            simpleMessage = EKSimpleMessage.init(title: title, description: description)
        }
        
        let notificationMessage = EKNotificationMessage.init(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
        
    }
}
