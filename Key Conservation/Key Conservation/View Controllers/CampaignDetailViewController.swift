//
//  CampaignDetailViewController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class CampaignDetailViewController: UIViewController {

    @IBOutlet weak var organizationPhoto: UIImageView!
    @IBOutlet weak var campaignTitle: UILabel!
    @IBOutlet weak var campaignLocation: UILabel!
    @IBOutlet weak var campaignPhoto: UIImageView!
    @IBOutlet weak var campaignFundedAmount: UILabel!
    @IBOutlet weak var campaignGoal: UILabel!
    @IBOutlet weak var campaignDeadline: UILabel!
    @IBOutlet weak var campaignCategory: UILabel!
    @IBOutlet weak var campaignDescription: UILabel!
    @IBOutlet weak var donationAmountTextField: UITextField!
    @IBOutlet weak var campaignSpecies: UILabel!
    
    var campaign: Campaign?
    var campaignController: CampaignController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }
    
    func updateViews() {
        guard let campaign = campaign else { return }
        campaignTitle.text = campaign.campaignName
        campaignLocation.text = campaign.location
        campaignFundedAmount.text = "\(campaign.fundingRaised?.clean ?? "$0")"
        campaignGoal.text = "of \(campaign.fundingGoal.clean) goal"
        campaignCategory.text = campaign.urgencyLevel
        campaignDescription.text = campaign.description
        campaignSpecies.text = campaign.species
        updateUrgencyColor()
        
            
        let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: campaign.deadline)
        let deadlineString = "\(diffInDays.day!) days to go"
        campaignDeadline.text = deadlineString
        
        organizationPhoto.layer.cornerRadius = self.organizationPhoto.frame.size.width / 2
        organizationPhoto.clipsToBounds = true
        
        // placeholder
        organizationPhoto.image = #imageLiteral(resourceName: "turtle")
        campaignPhoto.image = #imageLiteral(resourceName: "turtle")
//        fetchImage(for: campaign!)
    }
    
    func updateUrgencyColor() {
        switch campaign?.urgencyLevel {
        case "Critically Endangered":
            campaignCategory.textColor = UIColor.getCritEndangeredColor()
        case "Endangered":
            campaignCategory.textColor = UIColor.getEndangeredColor()
        case "Vulnerable":
            campaignCategory.textColor = UIColor.getVulnerableColor()
        case "Near Threatened":
            campaignCategory.textColor = UIColor.getNearThreatenedColor()
        default:
            return
        }
    }
    
    func fetchImage(for campaign: Campaign) {
        guard let campaignController = campaignController, let imageURL = campaign.imageURL else { return }
        campaignController.fetchImage(at: imageURL) { (result) in
            if let image = try? result.get() {
                DispatchQueue.main.async {
                    self.campaignPhoto.image = image
                }
            } else {
                print(result)
            }
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func donationButtonTapped(_ sender: Any) {
        guard let campaign = campaign, let campaignController = campaignController, let donationText = donationAmountTextField.text else { return }
        let donationAmount = Double(donationText)
        campaignController.updateCampaign(campaign: campaign, fundingGoal: campaign.fundingGoal, location: campaign.location, description: campaign.description, deadline: campaign.deadline, urgencyLevel: campaign.urgencyLevel, species: campaign.species, donationAmount: donationAmount) { (error) in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
}
