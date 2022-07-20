import UIKit

@available(iOS 13.0, *)
let appDelegate = UIApplication.shared.delegate as? AppDelegate
let standard = UserDefaults.standard
// MARK: - Device Details 

let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
var loginToken: String {
    get {
        return standard.string(forKey: "token") ?? ""
    }
    set {
        standard.setValue(newValue, forKey: "token")
    }
}
// Headers
func createHeaders() -> [String: String] {
    return ["app-id":"62d05ad557daac02e87e1e3a"]
}
func  isUserLogin() -> Bool {
    return standard.value(forKey: "isUserLogin") as? Bool ?? false
}

func  isSkipLogin() -> Bool {
    return standard.value(forKey: "isSkipLogin") as? Bool ?? false
}



enum AppStoryboard : String {
    case main = "Main"
    case auth = "Authentication"
    case home = "Dashbaord"
  
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
