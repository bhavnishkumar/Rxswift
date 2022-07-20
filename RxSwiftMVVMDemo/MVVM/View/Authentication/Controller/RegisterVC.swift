//
//  RegisterVC.swift
//  RxSwiftMVVMDemo
//
//  Created by Admin on 13/07/22.
//

import UIKit
import RxSwift
import RxCocoa


class RegisterVC: UIViewController {

    //MARK:- @IBOutlet & Variable
    @IBOutlet weak var resgiterBtn: UIButton!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmErrorLbl: UILabel!
    @IBOutlet weak var passwordErrorLbl: UILabel!
    
    @IBOutlet weak var emailErrorLbl: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nameErrorLbl: UILabel!
    
    // MARK: – View Model & RxSwift Setup
    var viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validationCheckOnTap()
    }
    
    //MARK:- Validation on Tap with multiple field
    private func validationCheckOnTap(){
        self.resgiterBtn.rx.tap.asObservable()
            .filter({ (_) -> Bool in
                self.viewModel.updateCredentials(name: self.nameTF.text ?? "", email: self.emailTF.text ?? "", password: self.passwordTF.text ?? "",confirmPassword: self.confirmPasswordTF.text ?? "")
                var status = true
                
                
                let namealidation = self.viewModel.validationInputField(val: .name)
                status = namealidation.status
                self.nameErrorLbl.isHidden = namealidation.status
                if namealidation.status{
                    hightLightTextField(color: .green, textField: self.nameTF)
                }else{
                    self.nameErrorLbl.text = namealidation.errorMsg
                    hightLightTextField(color: .red, textField: self.nameTF)
                    
                }
                
                
                let emailValidation = self.viewModel.validationInputField(val: .email)
                status = emailValidation.status
                self.emailErrorLbl.isHidden = emailValidation.status
                if emailValidation.status{
                    hightLightTextField(color: .green, textField: self.emailTF)
                }else{
                    self.emailErrorLbl.text = emailValidation.errorMsg
                    hightLightTextField(color: .red, textField: self.emailTF)
                    
                }
                
                let passwordValidation = self.viewModel.validationInputField(val: .password)
                status = passwordValidation.status
                self.passwordErrorLbl.isHidden = passwordValidation.status
                if passwordValidation.status{
                    hightLightTextField(color: .green, textField: self.passwordTF)
                }else{
                    self.passwordErrorLbl.text = passwordValidation.errorMsg
                    hightLightTextField(color: .red, textField: self.passwordTF)
                    
                }
                
                
                let cpasswordValidation = self.viewModel.validationInputField(val: .cpasswowrd)
                status = cpasswordValidation.status
                self.confirmErrorLbl.isHidden = cpasswordValidation.status
                if cpasswordValidation.status{
                    hightLightTextField(color: .green, textField: self.confirmPasswordTF)
                }else{
                    self.confirmErrorLbl.text = cpasswordValidation.errorMsg
                    hightLightTextField(color: .red, textField: self.confirmPasswordTF)
                    
                }
                
                return status
            })
            .subscribe { _ in
                //all field variefied
                
            }.disposed(by: disposeBag)
    }
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
}
