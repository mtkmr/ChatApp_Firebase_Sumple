//
//  ViewController.swift
//  ChatApp_Firebase_Sumple
//
//  Created by Masato Takamura on 2021/02/02.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.setupButton()
        logInButton.setupButton()
        
        titleLabel.text = ""
        let titleText = C.appName
        var charIndex = 0.0
        for char in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { [self] (timer) in
                titleLabel.text?.append(char)
            }
            charIndex += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }


}

