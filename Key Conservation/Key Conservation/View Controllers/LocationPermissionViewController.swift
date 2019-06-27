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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFeedView" {
            guard let campaignTableVC = segue.destination as? CampaignTableViewController else { return }
            campaignTableVC.user = user
        }
    }

    
    @IBAction func allowLocationButtonTapped(_ sender: Any) {
        // Stub function for adding location (stretch)
        // need update user details function/api
        self.performSegue(withIdentifier: "ShowFeedView", sender: self)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
