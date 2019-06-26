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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isOrg: Bool = false
    let userController = UserController()
    var user: User?
    var activeTextField: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationPermissionSegue" {
            guard let locationVC = segue.destination as? LocationPermissionViewController else { return }
            locationVC.user = user
            locationVC.userController = userController
        }
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            name != "",
            let email = emailTextField.text,
            email != "",
            let password = passwordTextField.text, password != "" else { return }

        user = User(id: nil, name: name, password: password, email: email, imageURL: nil, imageData: nil, isOrg: isOrg)
        userController.loginWith(user: user!, loginType: .signUp) { (error) in
            if let error = error {
                print(error)
                return
            }

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LocationPermissionSegue", sender: nil)
            }
        }
        performSegue(withIdentifier: "LocationPermissionSegue", sender: self)
    }
    
    @IBAction func supporterButtonTapped(_ sender: Any) {
        supporterButton.backgroundColor = .getBlueColor()
        supporterButton.titleLabel?.textColor = .white
        
        organizationButton.backgroundColor = .white
        organizationButton.titleLabel?.textColor = .black
        isOrg = false
    }
    
    @IBAction func organizationButtonTapped(_ sender: Any) {
        organizationButton.backgroundColor = .getBlueColor()
        organizationButton.titleLabel?.textColor = .white
        
        supporterButton.backgroundColor = .white
        supporterButton.titleLabel?.textColor = .black
        isOrg = true
    }
    
    @IBAction func profilePhotoButtonTapped(_ sender: Any) {
        // stub function for stretch goal
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
        switch activeTextField {
        case nameTextField:
            activeTextField?.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        case emailTextField:
            activeTextField?.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
//        case passwordTextField:
//            activeTextField?.resignFirstResponder()
        default:
            activeTextField?.resignFirstResponder()
        }
        return true
    }
}
