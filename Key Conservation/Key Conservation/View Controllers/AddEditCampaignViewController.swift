//
//  AddEditCampaignViewController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/25/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class AddEditCampaignViewController: UIViewController {

    @IBOutlet weak var campaignNameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var fundingGoalTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    @IBOutlet weak var saveCampaignButton: UIButton!
    @IBOutlet weak var criticallyEndangeredButton: UIButton!
    @IBOutlet weak var endangeredButton: UIButton!
    @IBOutlet weak var vulnerableButton: UIButton!
    @IBOutlet weak var nearThreatenedButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
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
    
    @IBAction func exitButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addCampaignPhotoButtonTapped(_ sender: Any) {
    }
    
    @IBAction func saveCampaignButtonTapped(_ sender: Any) {
    }
    
    @IBAction func criticallyEndangeredButtonTapped(_ sender: Any) {
    }
    
    @IBAction func endangeredButtonTapped(_ sender: Any) {
    }
    
    @IBAction func vulnerableButtonTapped(_ sender: Any) {
    }
    
    @IBAction func nearThreatenedButtonTapped(_ sender: Any) {
    }
}
