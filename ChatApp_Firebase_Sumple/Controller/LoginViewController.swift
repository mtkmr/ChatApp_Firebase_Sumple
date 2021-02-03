//
//  LoginViewController.swift
//  ChatApp_Firebase_Sumple
//
//  Created by Masato Takamura on 2021/02/02.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
              guard let strongSelf = self else { return }
                if let e = error {
                    print(e.localizedDescription)
                }else{
                    strongSelf.performSegue(withIdentifier: C.loginSegue, sender: self)
                }
            }
        }
        
    }
    
}
