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
    var isOrganization: Bool = true
    let userController = UserController()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        user = User(name: name, password: password, email: email, imageURL: nil, imageData: nil)
//        userController.loginWith(user: user!, loginType: .signUp) { (error) in
//            if let error = error {
//                print(error)
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "LocationPermissionSegue", sender: nil)
//            }
//        }
    }
    
    @IBAction func supporterButtonTapped(_ sender: Any) {
        supporterButton.backgroundColor = .getBlueColor()
        supporterButton.titleLabel?.textColor = .white
        
        organizationButton.backgroundColor = .white
        organizationButton.titleLabel?.textColor = .black
        isOrganization = false
    }
    
    @IBAction func organizationButtonTapped(_ sender: Any) {
        organizationButton.backgroundColor = .getBlueColor()
        organizationButton.titleLabel?.textColor = .white
        
        supporterButton.backgroundColor = .white
        supporterButton.titleLabel?.textColor = .black
        isOrganization = true
    }
    
    @IBAction func profilePhotoButtonTapped(_ sender: Any) {
    }
}
