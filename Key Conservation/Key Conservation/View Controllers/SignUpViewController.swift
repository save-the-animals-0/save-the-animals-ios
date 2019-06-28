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
            locationVC.user = currentUser
        }
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            name != "",
            let email = emailTextField.text,
            email != "",
            let password = passwordTextField.text, password != "" else { return }
        signUpButton.backgroundColor = UIColor.getGreenColor()
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
        
        print("sign up tapped")
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
        case passwordTextField:
            if passwordTextField.text != nil && passwordTextField.text != "" {
                signUpButton.backgroundColor = UIColor.getGreenColor()
            }
            activeTextField?.resignFirstResponder()
        default:
            activeTextField?.resignFirstResponder()
        }
        return true
    }
}
