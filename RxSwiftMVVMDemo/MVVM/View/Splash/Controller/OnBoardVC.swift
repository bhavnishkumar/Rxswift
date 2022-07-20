//
//  OnBoardVC.swift
//  RxSwiftMVVMDemo
//
//  Created by Bhavnish on 13/07/22.
//

import UIKit

class OnBoardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    // MARK: - @IBAction
    @IBAction func createNewBtn(_ sender: Any) {
        guard let nextVC = AppStoryboard.auth.instance.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let nextVC = AppStoryboard.auth.instance.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }


}
