//
//  SignInViewController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    private let userController = UserController()
    var user: User?
    var currentUser: User?  {
        didSet {
            performSegue(withIdentifier: "ShowFeed", sender: self)
        }
    }
    var activeTextField: UITextField?
    var hideBackButton: Bool = false
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        if hideBackButton {
            backButton.isHidden = true
        }
        
        signInButton.isEnabled = false
        signInButton.alpha = 0.25
        [emailTextField, passwordTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFeed" {
            guard let campaignTableVC = segue.destination as? CampaignTableViewController else { return }
            if let currentUser = currentUser {
               campaignTableVC.user = currentUser
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            email != "",
            let password = passwordTextField.text,
            password != "" else { return }
        user = User(id: nil, name: nil, password: password, email: email, imageURL: nil, imageData: nil, isOrg: nil)
        
        userController.loginWith(user: user!, loginType: .signIn) { (result) in
            if let bearer = try? result.get() {
                self.userController.getCurrentUser(for: bearer.token, completion: { (result) in
                    if let user = try? result.get() {
                        DispatchQueue.main.async {
                            self.currentUser = user
                        }
                    } else {
                        print("Result is: \(result)")
                    }
                })
            }
        }
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                self.signInButton.isEnabled = false
                self.signInButton.alpha = 0.25
                return
            }
        signInButton.isEnabled = true
        signInButton.alpha = 1
    }
    
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if activeTextField == emailTextField {
            activeTextField?.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        
        activeTextField?.resignFirstResponder()
        return true
    }
}


