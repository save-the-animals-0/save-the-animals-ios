//
//  GetStartedViewController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    let isFirstLaunch = UserDefaults.isFirstLaunch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isFirstLaunch {
            performSegue(withIdentifier: "NotFirstLaunchSegue", sender: self)
        }
    }
    
    @IBAction func getStartedButtonTapped(_ sender: Any) {
    }
    
}
