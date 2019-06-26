//
//  AddEditCampaignViewController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/25/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class AddEditCampaignViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var fundingGoalTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    @IBOutlet weak var saveCampaignButton: UIButton!
    @IBOutlet weak var criticallyEndangeredButton: UIButton!
    @IBOutlet weak var endangeredButton: UIButton!
    @IBOutlet weak var vulnerableButton: UIButton!
    @IBOutlet weak var nearThreatenedButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var campaign: Campaign? {
        didSet {
            updateViews()
        }
    }
    var campaignController: CampaignController?
    var category: String = "Critically Endangered"
    var activeTextField: UITextField?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        fundingGoalTextField.delegate = self
        deadlineTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    func updateViews() {
        locationTextField.text = campaign?.location
        fundingGoalTextField.text = "\(campaign?.fundingGoal ?? 0)"
        descriptionTextView.text = campaign?.description
        
        if let deadlineDate = campaign?.deadline {
            let diffInDays = Calendar.current.dateComponents([.day], from: deadlineDate, to: Date())
            let deadlineString = "\(diffInDays)"
            deadlineTextField.text = deadlineString
        }
        
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
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCampaignPhotoButtonTapped(_ sender: Any) {
        // stub action for photo stretch
    }
    
    @IBAction func saveCampaignButtonTapped(_ sender: Any) {
        guard let campaignController = campaignController else { return }
        guard let location = locationTextField.text, location != "",
            let fundingGoal = fundingGoalTextField.text, fundingGoal != "",
            let description = descriptionTextView.text, description != "",
            let deadlineInt = Int(deadlineTextField.text!) else { return }

        let today = Date()
        let deadlineDate = Calendar.current.date(byAdding: .day, value: deadlineInt, to: today)
        
        
        if let campaign = campaign {
            campaignController.updateCampaign(campaign: campaign, fundingGoal: Int(fundingGoal)!, location: location, description: description, deadline: deadlineDate!, urgencyLevel: category, species: nil) { (error) in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            campaign = Campaign(id: nil, campaignName: "placeholder", fundingGoal: Int(fundingGoal)!, location: location, description: description, deadline: deadlineDate!, urgencyLevel: category, species: nil, imageData: nil, imageURL: nil, fundingRaised: nil)
            campaignController.addCampaign(campaign: campaign!) { (error) in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
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

extension AddEditCampaignViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch activeTextField {
        case locationTextField:
            activeTextField?.resignFirstResponder()
            fundingGoalTextField.becomeFirstResponder()
        case fundingGoalTextField:
            activeTextField?.resignFirstResponder()
            deadlineTextField.becomeFirstResponder()
        case deadlineTextField:
            activeTextField?.resignFirstResponder()
        default:
            activeTextField?.resignFirstResponder()
        }
        return true
    }
}

extension AddEditCampaignViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
