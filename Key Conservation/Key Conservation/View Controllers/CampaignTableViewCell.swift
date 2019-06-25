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
    
    let campaignController = CampaignController()
    var campaign: Campaign? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        organizationPhoto.layer.cornerRadius = self.organizationPhoto.frame.size.width / 2
        organizationPhoto.clipsToBounds = true
        
        campaignTitle.text = campaign?.title
        campaignLocation.text = campaign?.location
        campaignFundedAmount.text = campaign?.fundingRaised
        campaignGoal.text = campaign?.fundingGoal
        campaignDeadline.text = campaign?.deadline
        campaignCategory.text = campaign?.category
        campaignDescription.text = campaign?.description
        fetchImage(for: campaign!)
    }
    
    func fetchImage(for campaign: Campaign) {
        campaignController.fetchImage(at: campaign.imageURL) { (result) in
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
