//
//  RegisterViewModel.swift
//  RxSwiftMVVMDemo
//
//  Created by Bhavnish on 31/05/22.
//  Copyright © 2021 Bhavnish Mac. All rights reserved.
//


import Foundation


struct RegisterCredentials {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var cpassword: String = ""
}


class RegisterViewModel:NSObject {
    
    // MARK: - Stored Properties
    
    //Here our model notify that was updated
    private var credentials = RegisterCredentials()
    
    deinit {
        print("RegisterViewModel Deinit")
    }
    
    enum Validation {
        case name
        case email
        case password
        case cpasswowrd
        case all
    }
    
    
    //Here we update our model
    func updateCredentials(name: String,email:String, password: String,confirmPassword:String) {
        credentials.name = name
        credentials.email = email
        credentials.password = password
        credentials.cpassword = confirmPassword
    }
    
    
    //MARK:- Sign Up Api Call
    func SignupAPI() {
        
    }
    
    //Validation
    private func validateName()-> ValidationModel{
        if credentials.name.trim().isEmpty{
            return ValidationModel.init(status: false, errorMsg: ErrorMessages.emptyNameError.value)
        }else{
            return ValidationModel.init(status: true, errorMsg: "")
        }
    }
    
    
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
        }else if !credentials.cpassword.isEmpty &&  credentials.password != credentials.cpassword{
            return ValidationModel.init(status: false, errorMsg:"")
        }
        else{
            return ValidationModel.init(status: true, errorMsg: "")
        }
    }
    
    
    private func cvalidatePass()-> ValidationModel{
        if credentials.cpassword.isEmpty{
            return ValidationModel.init(status: false, errorMsg: ErrorMessages.emptyConfirmPasswordError.value)
        }else if !credentials.password.isEmpty && credentials.password != credentials.cpassword{
            return ValidationModel.init(status: false, errorMsg: ErrorMessages.doestMatchConfirmPasswordAndPsswordError.value)
        }
        else{
            return ValidationModel.init(status: true, errorMsg: "")
        }
    }
    
    
    
    func validationInputField(val:Validation) -> ValidationModel{
        switch val{
        case .name:
            return validateName()
        case .email:
            return validateEmail()
        case .password:
            return validatePass()
        case .cpasswowrd:
            return cvalidatePass()
        default:
            break
        }
        return ValidationModel.init(status: true, errorMsg: "")
    }
}

