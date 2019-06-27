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
    private let userController = UserController()
    var user: User?
    var currentUser: User?  {
        didSet {
            performSegue(withIdentifier: "ShowFeed", sender: self)
        }
    }
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if activeTextField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        activeTextField?.resignFirstResponder()
        return true
    }
}


