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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signInButtonTapped(_ sender: Any) {
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
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
