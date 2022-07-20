//
//  LoginViewModel.swift
//  RxSwiftMVVMDemo
//
//  Created by Bhavnish on 31/05/22.
//  Copyright © 2021 Bhavnish Mac. All rights reserved.
//


import Foundation
import RxSwift
import UIKit

struct ValidationResponseModel {
    var valid: Bool
    var errMsg: String
}

struct LoginCredentials {
    var email: String = ""
    var password: String = ""
}

struct ValidationModel{
    var status:Bool = false
    var errorMsg:String = ""
}

class LoginViewModel:NSObject {
    
    // MARK: - Stored Properties
    var validationSubject = PublishSubject<ValidationResponseModel>()
    var validationObserver: Observable<ValidationResponseModel> {
        return validationSubject.asObserver()
    }
    
    //Here our model notify that was updated
    private var credentials = LoginCredentials()
    
    deinit {
        print("LoginviewModel Deinit")
    }
    
    enum Validation {
        case email
        case password
        case all
    }
    
    
    //Here we update our model
    func updateCredentials(username: String, password: String) {
        credentials.email = username
        credentials.password = password
    }
    
    
    //MARK:- Login Apis Call
    func login(UIViewController:UIViewController) {
        if credentials.email == "Bhavnish.1@gmail.com" &&  credentials.password == "123456"{
          
            self.validationSubject.onNext(.init(valid: true, errMsg: ""))
            Toast.shared.showAlert(type: .success, message:  "Login Suceessfully", style:ToastStyle.notificationBanner )
        }else{
            self.validationSubject.onNext(.init(valid: false, errMsg: ""))
            Toast.shared.showAlert(type: .validationFailure, message: "You have enter wrong credetial!", style:ToastStyle.notificationBanner )
        }
    }
    
    //Validation
    private func validateEmail()-> ValidationModel{
        if credentials.email.trim().isEmpty{
            return ValidationModel.init(status: false, errorMsg: ErrorMessages.emptyEmailError.value)
        }else if !(credentials.email.trim().isValidEmail()) {
            return ValidationModel.init(status: false, errorMsg: ErrorMessages.invalidEmailError.value)
        }else{
            return ValidationModel.init(status: true, errorMsg: "")
        }
    }
    
    private func validatePass()-> ValidationModel{
        if credentials.password.isEmpty{
            return ValidationModel.init(status: false, errorMsg: ErrorMessages.empltyPasswordError.value)
        }else{
            return ValidationModel.init(status: true, errorMsg: "")
        }
    }
    
    
    func validationInputField(val:Validation) -> ValidationModel{
        switch val{
        case .email:
            return validateEmail()
        case .password:
            return validatePass()
        default:
            break
        }
        return ValidationModel.init(status: true, errorMsg: "")
    }
}
