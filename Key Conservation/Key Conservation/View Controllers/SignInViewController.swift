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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFeed" {
            guard let campaignTableVC = segue.destination as? CampaignTableViewController else { return }
            campaignTableVC.userController = userController
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
        performSegue(withIdentifier: "ShowFeed", sender: self)
                userController.loginWith(user: user!, loginType: .signIn) { (error) in
                    if let error = error {
                        print(error)
                        return
                    }
        
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ShowFeed", sender: self)
                    }
                }
        
    }
    
}
