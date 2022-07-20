//
//  LoginVC.swift
//  RxSwiftMVVMDemo
//
//  Created by Admin on 13/07/22.
//

import UIKit
import RxSwift
import RxCocoa


class LoginVC: UIViewController {
    
    // MARK: – @IBOutlet & Varibale
    @IBOutlet weak var passwordErrorLbl: UILabel!
    @IBOutlet weak var emailErrorLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var emailIDTF: UITextField!
    
    var viewModel = LoginViewModel()
    // MARK: – View Model & RxSwift Setup
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validationCheckOnTap()
        
        emailIDTF.rx.controlEvent(.editingChanged).subscribe(onNext: { [unowned self] in
            if let text = self.emailIDTF.text {
                self.emailIDTF.text = String(text.prefix(150))
            }
        }).disposed(by: disposeBag)
        rxSubscribers()
        
    }
    
    // MARK: - APIs
    /// Rxswift subscribers
    private func rxSubscribers() {
        self.viewModel.validationObserver.subscribe(onNext: { [weak self] response in
            
            if response.valid {
                standard.setValue(true, forKey: "isUserLogin")
                guard let nextVC = AppStoryboard.home.instance.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
                if #available(iOS 13, *) {
                    guard let sceneDelegate =  UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    let nav = UINavigationController.init(rootViewController: nextVC)
                    nav.isNavigationBarHidden = true
                    sceneDelegate.window?.rootViewController = nav
                    sceneDelegate.window?.makeKeyAndVisible()
                }else{
                    
                    
                    guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let nav = UINavigationController.init(rootViewController: nextVC)
                    nav.isNavigationBarHidden = true
                    appDelegate.window?.rootViewController = nav
                    appDelegate.window?.makeKeyAndVisible()
                }
            }else{
                
            }
        }).disposed(by: disposeBag)
    }
    
    
    
    //MARK:- Validation on Tap with multiple field
    private func validationCheckOnTap(){
        self.loginBtn.rx.tap.asObservable()
            .filter({ (_) -> Bool in
                self.viewModel.updateCredentials(username: self.emailIDTF.text!, password: self.passwordTf.text!)
                var status = true
                
                let emailValidation = self.viewModel.validationInputField(val: .email)
                status = emailValidation.status
                self.emailErrorLbl.isHidden = emailValidation.status
                if emailValidation.status{
                    hightLightTextField(color: .green, textField: self.emailIDTF)
                }else{
                    self.emailErrorLbl.text = emailValidation.errorMsg
                    hightLightTextField(color: .red, textField: self.emailIDTF)
                    
                }
                
                let passwordValidation = self.viewModel.validationInputField(val: .password)
                status = passwordValidation.status
                self.passwordErrorLbl.isHidden = passwordValidation.status
                if passwordValidation.status{
                    hightLightTextField(color: .green, textField: self.passwordTf)
                }else{
                    self.passwordErrorLbl.text = passwordValidation.errorMsg
                    hightLightTextField(color: .red, textField: self.passwordTf)
                    
                }
                return status
            })
            .subscribe { _ in
                //all field variefied
                self.viewModel.login(UIViewController: self) //hit api
                
            }.disposed(by: disposeBag)
    }
    
    //MARK:- @IBAction
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
}



//MARK:- Hightlight TextField
func hightLightTextField(color:UIColor,textField:UITextField){
    textField.layer.borderColor = color.cgColor
    textField.layer.borderWidth = 1
}


extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var sceneDelegate: SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else { return nil }
        return delegate
    }
}

extension UIViewController {
    var window: UIWindow? {
        if #available(iOS 13, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
            return window
        }
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate, let window = delegate.window else { return nil }
        return window
    }
}
