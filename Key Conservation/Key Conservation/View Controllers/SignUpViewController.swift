//
//  SignUpViewController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var supporterButton: UIButton!
    @IBOutlet weak var organizationButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isOrg: Bool = false
    private let userController = UserController()
    var user: User?
    var activeTextField: UITextField?
    var currentUser: User?  {
        didSet {
            performSegue(withIdentifier: "LocationPermissionSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add observers and delegates for keyboard handling
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.25
        [emailTextField, passwordTextField, nameTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationPermissionSegue" {
            guard let locationVC = segue.destination as? LocationPermissionViewController else { return }
            locationVC.user = currentUser
        }
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            name != "",
            let email = emailTextField.text,
            email != "",
            let password = passwordTextField.text, password != "" else { return }
        signUp(name: name, email: email, password: password)
    }
    
    @IBAction func supporterButtonTapped(_ sender: Any) {
        supporterButton.backgroundColor = .getBlueColor()
        supporterButton.setTitleColor(.white, for: .normal)
        
        organizationButton.backgroundColor = .white
        organizationButton.setTitleColor(.black, for: .normal)
        organizationButton.titleLabel?.textColor = .black
        isOrg = false
    }
    
    @IBAction func organizationButtonTapped(_ sender: Any) {
        organizationButton.backgroundColor = .getBlueColor()
        organizationButton.setTitleColor(.white, for: .normal)
        
        supporterButton.backgroundColor = .white
        supporterButton.setTitleColor(.black, for: .normal)
        isOrg = true
    }
    
    @IBAction func profilePhotoButtonTapped(_ sender: Any) {
        // stub function for stretch goal
    }
    
    // sign up the user and assign their user object so it can be passed
    func signUp(name: String, email: String, password: String) {
        user = User(id: nil, name: name, password: password, email: email, imageURL: nil, imageData: nil, isOrg: isOrg)
        userController.signUpWith(user: user!, loginType: .signUp) { (error) in
            if let error = error {
                print(error)
                return
            }
            
            self.userController.loginWith(user: self.user!, loginType: .signIn) { (result) in
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
    
    // sign up button handling for enabling/disabling based on text entry
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let name = nameTextField.text, !name.isEmpty
            else {
                self.signUpButton.isEnabled = false
                self.signUpButton.alpha = 0.25
                return
        }
        signUpButton.isEnabled = true
        UIView.animate(withDuration: 1) {
            self.signUpButton.alpha = 1
        }
    }
    
    // keyboard handling
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height) * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if activeTextField == nameTextField {
            activeTextField?.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if activeTextField == emailTextField {
            activeTextField?.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if activeTextField == passwordTextField {
            activeTextField?.resignFirstResponder()
        }
        return true
    }
}
