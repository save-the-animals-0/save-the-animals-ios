//
//  CampaignTableViewCell.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

protocol CampaignTableViewCellDelegate: class {
    func editButtonTapped(cell: CampaignTableViewCell)
}

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
    @IBOutlet weak var campaignSpecies: UILabel!
    
    let campaignController = CampaignController()
    var campaign: Campaign? {
        didSet {
            updateViews()
        }
    }
    var user: User?
    weak var delegate: CampaignTableViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.delegate?.editButtonTapped(cell: self)
    }
    
    func updateViews() {
        guard let campaign = campaign else { return }
        campaignTitle.text = campaign.campaignName
        campaignLocation.text = campaign.location
        campaignFundedAmount.text = "\(campaign.fundingRaised?.clean ?? "$0")"
        campaignGoal.text = "of \(campaign.fundingGoal.clean) goal"
        campaignCategory.text = campaign.urgencyLevel
        campaignCategory.textColor = UIColor.getUrgencyColor(urgencyLevel: campaign.urgencyLevel)
        campaignDescription.text = campaign.description
        campaignSpecies.text = "Species: \(campaign.species)"
        
        let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: campaign.deadline)
        let deadlineString = "\(diffInDays.day!) days to go"
        campaignDeadline.text = deadlineString
        
        organizationPhoto.layer.cornerRadius = self.organizationPhoto.frame.size.width / 2
        organizationPhoto.clipsToBounds = true
        
        // placeholders
        campaignPhoto.image = #imageLiteral(resourceName: "turtle")
        organizationPhoto.image = #imageLiteral(resourceName: "turtle")
//        fetchImage(for: campaign!) //stretch goal
        
        editCampaignButton.isHidden = true
        if let name = user?.name {
            if campaign.campaignName == name {
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
