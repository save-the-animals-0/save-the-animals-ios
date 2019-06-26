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
        
        campaignTitle.text = campaign?.campaignName
        campaignLocation.text = campaign?.location
        campaignFundedAmount.text = campaign?.fundingRaised
        campaignGoal.text = "\(campaign?.fundingGoal ?? 0)"
        campaignCategory.text = campaign?.urgencyLevel
        campaignDescription.text = campaign?.description
        
        if let deadlineDate = campaign?.deadline {
            let diffInDays = Calendar.current.dateComponents([.day], from: deadlineDate, to: Date())
            let deadlineString = "\(diffInDays)"
            campaignDeadline.text = deadlineString
        }
//        fetchImage(for: campaign!) //stretch goal
        
        editCampaignButton.isHidden = true
        if let campaignName = campaign?.campaignName, let userName = user?.name {
            if campaignName == userName {
                editCampaignButton.isHidden = false
            }
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
