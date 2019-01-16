//
//  SignInViewController.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 15/09/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    // textfields
    @IBOutlet weak var userEmailTxt: UITextField!
    @IBOutlet weak var userPasswordTxt: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signinBtn.isEnabled = false
        signinBtn.backgroundColor = UIColor.white
        signinBtn.setTitleColor(UIColor.darkText , for: UIControlState.normal)
        dealTxtField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Api.User.CURRENT_USER != nil {
            self.performSegue(withIdentifier: "signinToTab", sender: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    // signin btn clicked
    @IBAction func signinBtn_clicked(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        Authentication.signin(email: userEmailTxt.text!, password: userPasswordTxt.text!, OnSuccess: {
            ProgressHUD.showSuccess("Login in successfully")
            self.performSegue(withIdentifier: "signinToTab", sender: nil)
            }, OnFailure: { error in
                ProgressHUD.showError(error!)
                print(error!)
        })
    }
    
    
    func dealTxtField() {
        userEmailTxt.addTarget(self, action: #selector(SignInViewController.textFieldChanged), for: UIControlEvents.editingChanged)
        userPasswordTxt.addTarget(self, action: #selector(SignInViewController.textFieldChanged), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldChanged() {
        guard let email = userEmailTxt.text, !email.isEmpty,
            let password = userPasswordTxt.text, !password.isEmpty else {
                signinBtn.backgroundColor = UIColor.white
                signinBtn.setTitleColor(UIColor.darkText , for: UIControlState.normal)
                signinBtn.isEnabled = false
                return
        }
        signinBtn.backgroundColor = UIColor.lightGray
        signinBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        signinBtn.isEnabled = true
    }
    
 

}// class close
