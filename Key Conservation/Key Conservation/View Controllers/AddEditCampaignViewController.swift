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
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var saveCampaignButton: UIButton!
    @IBOutlet weak var criticallyEndangeredButton: UIButton!
    @IBOutlet weak var endangeredButton: UIButton!
    @IBOutlet weak var vulnerableButton: UIButton!
    @IBOutlet weak var nearThreatenedButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteCampaignButton: UIButton!
    
    var campaign: Campaign?
    var campaignController: CampaignController?
    var category: String = "Critically Endangered"
    var activeTextField: UITextField?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteCampaignButton.isHidden = true
        updateViews()
        locationTextField.delegate = self
        speciesTextField.delegate = self
        fundingGoalTextField.delegate = self
        deadlineTextField.delegate = self
        descriptionTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddEditCampaignViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddEditCampaignViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        saveCampaignButton.isEnabled = false
        saveCampaignButton.alpha = 0.25
        [locationTextField, speciesTextField,fundingGoalTextField, deadlineTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    func updateViews() {
        guard let campaign = campaign else { return }
        locationTextField.text = campaign.location
        speciesTextField.text = campaign.species
        fundingGoalTextField.text? = "\(campaign.fundingGoal)"
        descriptionTextView.text? = campaign.description
        titleLabel.text = "Edit Campaign"
        deleteCampaignButton.isHidden = false
        
        let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: campaign.deadline)
        let deadlineString = "\(diffInDays.day!)"
        deadlineTextField.text = deadlineString
 
        switch campaign.urgencyLevel {
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
            let species = speciesTextField.text, species != "",
            let deadlineInt = Int(deadlineTextField.text!) else { return }
        let today = Date()
        let deadlineDate = Calendar.current.date(byAdding: .day, value: deadlineInt, to: today)
        
        if let campaign = campaign {
            print("updating campaign")
            campaignController.updateCampaign(campaign: campaign, fundingGoal: Double(fundingGoal)!, location: location, description: description, deadline: deadlineDate!, urgencyLevel: category, species: species, donationAmount: nil) { (error) in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            guard let name = user?.name else { return }
            campaign = Campaign(id: nil, campaignName: name, fundingGoal: Double(fundingGoal)!, location: location, description: description, deadline: deadlineDate!, urgencyLevel: category, species: species, imageData: nil, imageURL: nil, fundingRaised: nil)
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
    
    @IBAction func deleteCampaignButtonTapped(_ sender: Any) {
        guard let campaignController = campaignController, let campaign = campaign else { return }
        campaignController.deleteCampaign(campaign: campaign) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    @IBAction func criticallyEndangeredButtonTapped(_ sender: Any) {
        criticallyEndangeredButton.backgroundColor = .getCritEndangeredColor()
        criticallyEndangeredButton.setTitleColor(.white, for: .normal)
        
        endangeredButton.backgroundColor = .white
        endangeredButton.setTitleColor(.black, for: .normal)
        vulnerableButton.backgroundColor = .white
        vulnerableButton.setTitleColor(.black, for: .normal)
        nearThreatenedButton.backgroundColor = .white
        nearThreatenedButton.setTitleColor(.black, for: .normal)
        category = "Critically Endangered"
    }
    
    @IBAction func endangeredButtonTapped(_ sender: Any) {
        endangeredButton.backgroundColor = .getEndangeredColor()
        endangeredButton.setTitleColor(.white, for: .normal)
        
        criticallyEndangeredButton.backgroundColor = .white
        criticallyEndangeredButton.setTitleColor(.black, for: .normal)
        vulnerableButton.backgroundColor = .white
        vulnerableButton.setTitleColor(.black, for: .normal)
        nearThreatenedButton.backgroundColor = .white
        nearThreatenedButton.setTitleColor(.black, for: .normal)
        category = "Endangered"
    }
    
    @IBAction func vulnerableButtonTapped(_ sender: Any) {
        vulnerableButton.backgroundColor = .getVulnerableColor()
        vulnerableButton.setTitleColor(.white, for: .normal)
        
        criticallyEndangeredButton.backgroundColor = .white
        criticallyEndangeredButton.setTitleColor(.black, for: .normal)
        endangeredButton.backgroundColor = .white
        endangeredButton.setTitleColor(.black, for: .normal)
        nearThreatenedButton.backgroundColor = .white
        nearThreatenedButton.setTitleColor(.black, for: .normal)
        category = "Vulnerable"
    }
    
    @IBAction func nearThreatenedButtonTapped(_ sender: Any) {
        nearThreatenedButton.backgroundColor = .getNearThreatenedColor()
        nearThreatenedButton.setTitleColor(.white, for: .normal)
        
        criticallyEndangeredButton.backgroundColor = .white
        criticallyEndangeredButton.setTitleColor(.black, for: .normal)
        endangeredButton.backgroundColor = .white
        endangeredButton.setTitleColor(.black, for: .normal)
        vulnerableButton.backgroundColor = .white
        vulnerableButton.setTitleColor(.black, for: .normal)
        category = "Vulnerable"
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard let location = locationTextField.text, !location.isEmpty,
            let species = speciesTextField.text, !species.isEmpty,
            let fundingGoal = fundingGoalTextField.text, !fundingGoal.isEmpty,
            let deadline = deadlineTextField.text, !deadline.isEmpty
            else {
                self.saveCampaignButton.isEnabled = false
                self.saveCampaignButton.alpha = 0.25
                return
        }
        self.saveCampaignButton.isEnabled = true
        UIView.animate(withDuration: 1) {
            self.saveCampaignButton.alpha = 1
        }
        
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
            speciesTextField.becomeFirstResponder()
        case speciesTextField:
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
