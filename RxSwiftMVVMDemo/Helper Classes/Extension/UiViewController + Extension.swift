
import Foundation
import UIKit
// MARK: UIViewController
extension UIViewController {
    
    var topViewController: UIViewController {
        switch self {
        case is UINavigationController:
            return (self as! UINavigationController).visibleViewController?.topViewController ?? self
        case is UITabBarController:
            return (self as! UITabBarController).selectedViewController?.topViewController ?? self
        default:
            return presentedViewController?.topViewController ?? self
        }
    }
 
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        let vc = appStoryboard.viewController(viewControllerClass: self)
        return vc
    }
    
    
    func setNavThemeOrignal(title: String, leftBtns: [UIBarButtonItem]?, rightBtns: [UIBarButtonItem]?, hideShadow: Bool) {
        var textColor = Theme.Colors.primaryColor.instance
        if Theme.Colors.primaryColor.instance.isLight() ?? true {
            textColor = Theme.Colors.primaryColor.instance
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if hideShadow {
            self.navigationController?.navigationBar.shadowImage = UIImage()}
        self.navigationController?.navigationBar.tintColor = textColor
        self.navigationController?.navigationBar.barTintColor = Theme.Colors.white.instance
        
        self.navigationItem.title = title.uppercased()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .default
        
        let font = UIFont.init(name: Theme.FontStyle.medium.rawValue, size: CGFloat(Theme.FontSize.large.rawValue))
        let attributesNormal: [NSAttributedString.Key: Any] = [.foregroundColor: textColor, .font: font ?? UIFont.systemFontSize]
        self.navigationController?.navigationBar.titleTextAttributes = attributesNormal
        
        // Transprent issue for iOS 15
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = nil
            appearance.titleTextAttributes = attributesNormal
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        }
        // Add animation
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        if (leftBtns?.count ?? 0) > 0 {
            self.navigationItem.leftBarButtonItems = leftBtns
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font ?? UIFont.systemFontSize], for: UIControl.State.normal)
        } else {
            self.navigationItem.leftBarButtonItems = nil
        }
        
        if (rightBtns?.count ?? 0) > 0 {
            self.navigationItem.rightBarButtonItems = rightBtns
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font ?? UIFont.systemFontSize], for: UIControl.State.normal)
        } else {
            self.navigationItem.rightBarButtonItems = nil
        }
    }
    
    
    
}
// MARK: UINavigationController
extension UINavigationController {
    
    func backButton(_ image: String, navController: UINavigationController?) {
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: image), for: .normal)
        backbutton.setTitle("", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        navController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }
    
    @objc func backAction(_ controller: UINavigationController?) {
        controller?.popViewController(animated: true)
    }
}



extension UIViewController{
    var isOnScreen: Bool{
        return self.isViewLoaded && view.window != nil
    }
}


extension UIViewController {
    static var activityIndicatorTag = 12345

    func startLoading() {
        stopLoading()

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.tag = UIViewController.activityIndicatorTag
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        activityIndicator.center = view.center
        activityIndicator.cornerRadius = 8
        activityIndicator.hidesWhenStopped = true
        activityIndicator.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        activityIndicator.style = .white
         

        DispatchQueue.main.async {
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }

    func stopLoading() {
        let activityIndicator = view.viewWithTag(UIViewController.activityIndicatorTag) as? UIActivityIndicatorView
        DispatchQueue.main.async {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
        }
    }
}

