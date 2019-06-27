//
//  CampaignTableViewCell.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class CampaignTableViewCell: UITableViewCell {

    @IBOutlet weak var organizationPhoto: UIImageView!
    @IBOutlet weak var campaignTitle: UILabel!
    @IBOutlet weak var campaignLocation: UILabel!
    @IBOutlet weak var campaignPhoto: UIImageView!
    @IBOutlet weak var campaignFundedAmount: UILabel!
    @IBOutlet weak var campaignGoal: UILabel!
    @IBOutlet weak var campaignDeadline: UILabel!
    @IBOutlet weak var campaignCategory: UILabel!
    @IBOutlet weak var campaignDescription: UILabel!
    @IBOutlet weak var editCampaignButton: UIButton!
    
    let campaignController = CampaignController()
    var campaign: Campaign? {
        didSet {
            updateViews()
        }
    }
    var user: User?
    
    func updateViews() {
        organizationPhoto.layer.cornerRadius = self.organizationPhoto.frame.size.width / 2
        organizationPhoto.clipsToBounds = true
        
        guard let campaign = campaign else { return }
        campaignTitle.text = campaign.campaignName
        campaignLocation.text = campaign.location
        campaignFundedAmount.text = "$\(campaign.fundingRaised ?? 0)"
        campaignGoal.text = "of $\(campaign.fundingGoal) goal"
        campaignCategory.text = campaign.urgencyLevel
        campaignCategory.textColor = UIColor.getUrgencyColor(urgencyLevel: campaign.urgencyLevel)
        campaignDescription.text = campaign.description
        
        let diffInDays = Calendar.current.dateComponents([.day], from: campaign.deadline, to: Date())
        let deadlineString = "Deadline: \(diffInDays.day!) days to go"
        campaignDeadline.text = deadlineString
//        fetchImage(for: campaign!) //stretch goal
        
        editCampaignButton.isHidden = true
        if campaign.campaignName == user?.name {
            editCampaignButton.isHidden = false
        }
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
        guard let imageURL = campaign.imageURL else { return }
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
}
