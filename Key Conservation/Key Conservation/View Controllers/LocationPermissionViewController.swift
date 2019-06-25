//
//  LocationPermissionViewController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class LocationPermissionViewController: UIViewController {
    
    var user: User?
    var userController: UserController?
    
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
    
    @IBAction func allowLocationButtonTapped(_ sender: Any) {
        // Stub function for adding location (stretch)
        // need update user details function/api
        //self.performSegue(withIdentifier: "ShowFeedView", sender: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
