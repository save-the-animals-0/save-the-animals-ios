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
    
    var isOrg: Bool = false
    let userController = UserController()
    var user: User?
    var activeTextField: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: Notification.Name.UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: Notification.Name.UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
//    @objc func keyboardWillShow(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            print("notification: Keyboard will show")
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//
//    }
//
//    func keyboardWillHide(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0 {
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        
//        let lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        activeTextField = nil
        return true
    }
}
