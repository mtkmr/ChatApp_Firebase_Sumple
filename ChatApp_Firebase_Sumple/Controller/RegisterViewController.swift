//
//  RegisterViewController.swift
//  ChatApp_Firebase_Sumple
//
//  Created by Masato Takamura on 2021/02/02.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            //
            Auth.auth().createUser(withEmail: email, password: password) { [self]
                authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                }else{
                    performSegue(withIdentifier: C.registerSegue, sender: self)
                }
            }
        }
        
        
    }
    
}
