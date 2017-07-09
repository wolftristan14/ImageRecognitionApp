//
//  LogInViewController.swift
//  ImageRecognitionApp
//
//  Created by Tristan Wolf on 2017-07-09.
//  Copyright © 2017 Tristan Wolf. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "You must enter your username and password", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
                
                if error == nil {
                    print("Logged in")
                    
                    //self.navigationController?.popViewController(animated: true)
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "viewController")
                    self.present(viewController!, animated: true, completion: nil)
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Incorrect username and/or password", preferredStyle: .alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
}
