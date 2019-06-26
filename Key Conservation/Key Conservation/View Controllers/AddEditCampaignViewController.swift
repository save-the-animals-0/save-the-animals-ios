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
    
    var campaign: Campaign? {
        didSet {
            updateViews()
        }
    }
    var campaignController: CampaignController?
    var category: String = "Critically Endangered"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews() {
        campaignNameTextField.text = campaign?.campaignName
        locationTextField.text = campaign?.location
        fundingGoalTextField.text = campaign?.fundingGoal
        deadlineTextField.text = campaign?.deadline
        descriptionTextView.text = campaign?.description
        
        switch campaign?.urgencyLevel {
        case "Critically Endangered":
            criticallyEndangeredButtonTapped(self)
        case "Endangered":
            endangeredButtonTapped(self)
        case "Vulnerable":
            vulnerableButtonTapped(self)
        case "Near Threatened":
            nearThreatenedButtonTapped(self)
        default:
            criticallyEndangeredButtonTapped(self)
        }
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
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCampaignPhotoButtonTapped(_ sender: Any) {
        // stub action for photo stretch
    }
    
    @IBAction func saveCampaignButtonTapped(_ sender: Any) {
        guard let campaignController = campaignController else { return }
        guard let name = campaignNameTextField.text, name != "",
            let location = locationTextField.text, location != "",
            let fundingGoal = fundingGoalTextField.text, fundingGoal != "",
            let deadline = deadlineTextField.text, deadline != "",
            let description = descriptionTextView.text, description != "" else { return }
        if let campaign = campaign {
            // edit campaign function
        } else {
            campaign = Campaign(id: nil, campaignName: name, fundingGoal: fundingGoal, location: location, description: description, deadline: deadline, urgencyLevel: category, species: nil, imageData: nil, imageURL: nil, fundingRaised: nil)
            campaignController.addCampaign(campaign: campaign!) { (error) in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func criticallyEndangeredButtonTapped(_ sender: Any) {
        criticallyEndangeredButton.backgroundColor = .getCritEndangeredColor()
        criticallyEndangeredButton.titleLabel?.textColor = .white
        
        endangeredButton.backgroundColor = .white
        endangeredButton.titleLabel?.textColor = .black
        vulnerableButton.backgroundColor = .white
        vulnerableButton.titleLabel?.textColor = .black
        nearThreatenedButton.backgroundColor = .white
        nearThreatenedButton.titleLabel?.textColor = .black
        category = "Critically Endangered"
    }
    
    @IBAction func endangeredButtonTapped(_ sender: Any) {
        endangeredButton.backgroundColor = .getEndangeredColor()
        endangeredButton.titleLabel?.textColor = .white
        
        criticallyEndangeredButton.backgroundColor = .white
        criticallyEndangeredButton.titleLabel?.textColor = .black
        vulnerableButton.backgroundColor = .white
        vulnerableButton.titleLabel?.textColor = .black
        nearThreatenedButton.backgroundColor = .white
        nearThreatenedButton.titleLabel?.textColor = .black
        category = "Endangered"
    }
    
    @IBAction func vulnerableButtonTapped(_ sender: Any) {
        vulnerableButton.backgroundColor = .getVulnerableColor()
        vulnerableButton.titleLabel?.textColor = .white
        
        criticallyEndangeredButton.backgroundColor = .white
        criticallyEndangeredButton.titleLabel?.textColor = .black
        endangeredButton.backgroundColor = .white
        endangeredButton.titleLabel?.textColor = .black
        nearThreatenedButton.backgroundColor = .white
        nearThreatenedButton.titleLabel?.textColor = .black
        category = "Vulnerable"
    }
    
    @IBAction func nearThreatenedButtonTapped(_ sender: Any) {
        nearThreatenedButton.backgroundColor = .getNearThreatenedColor()
        nearThreatenedButton.titleLabel?.textColor = .white
        
        criticallyEndangeredButton.backgroundColor = .white
        criticallyEndangeredButton.titleLabel?.textColor = .black
        endangeredButton.backgroundColor = .white
        endangeredButton.titleLabel?.textColor = .black
        vulnerableButton.backgroundColor = .white
        vulnerableButton.titleLabel?.textColor = .black
        category = "Vulnerable"
    }
}
