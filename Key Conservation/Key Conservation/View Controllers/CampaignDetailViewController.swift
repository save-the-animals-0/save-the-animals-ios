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
        campaignFundedAmount.text = "$\(campaign.fundingRaised ?? 0)"
        campaignGoal.text = "of $\(campaign.fundingGoal) goal"
        campaignCategory.text = campaign.urgencyLevel
        campaignDescription.text = campaign.description
        
            
        let diffInDays = Calendar.current.dateComponents([.day], from: campaign.deadline, to: Date())
        let deadlineString = "Deadline: \(diffInDays.day!) days to go"
        campaignDeadline.text = deadlineString
        
        organizationPhoto.layer.cornerRadius = self.organizationPhoto.frame.size.width / 2
        organizationPhoto.clipsToBounds = true
        
        // placeholder
        organizationPhoto.image = #imageLiteral(resourceName: "turtle")
        campaignPhoto.image = #imageLiteral(resourceName: "turtle")
//        fetchImage(for: campaign!)
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
    }
}
