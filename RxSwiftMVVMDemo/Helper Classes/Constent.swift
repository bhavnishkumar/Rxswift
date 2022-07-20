//
//  Constent.swift
//  RxSwiftMVVMDemo
//
//  Created by Bhavnish on 31/05/22.
//  Copyright © 2021 Bhavnish Mac. All rights reserved.
//


import Foundation


//MARK:- ErrorMessages
enum ErrorMessages: String{
    case emptyNameError = "Please enter  full name"
    case emptyNameLengthError = "must contain 40 characters or less"
    case validNameError = "Please enter valid name"
    case emptyEmailError = "Please enter email"
    case invalidEmailError = "Please enter valid email" //(in case of invalid email)
    case emptyFirstNameError = "Please enter first name"


    case empltyPasswordError = "Please enter password"
    case empltyOldPasswordError = "Please enter current password"
    case empltyNewPasswordError = "Please enter new password"
    case emptyLimitPasswordError = "Password criteria should be match"
    case emptyConfirmPasswordError = "Please enter confirm password"
    case emptyConfirmNewPasswordError = "New password and confirm password should be same"
    case doestMatchConfirmPasswordAndPsswordError = "Password and confirm password does not match"
    case empltyProfileImgError = "Please select profile image"
    case emptyDobError = "Please enter date of birth"
    case empltyPhoneNumberError = "Please enter mobile number"
    case ValidPhoneNumberError =  "Please enter valid mobile number"
    case emptyTipNameError = "Please enter tip name"
    case emptyDescriptionError = "Please enter description"
    case emptyAboutError = "Please enter about"
    case emptyBioError = "Please enter bio"
    case empltyAcceptTermsAndConditionError = "Please accept Term of Use & Privacy Policy"
    case empltyImgError = "Please select image"
    case empltyMsgError = "Please enter message"
    
    case forgotPasswpordSuccess = "Email has been sent to your registered email"
    case changePasswordSuccess = "Password changed successfully"
    
    
    var value: String{
        return self.rawValue
    }
}

