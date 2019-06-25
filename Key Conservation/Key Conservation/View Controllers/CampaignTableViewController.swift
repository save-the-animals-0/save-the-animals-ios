//
//  CampaignTableViewController.swift
//  Key Conservation
//
//  Created by Sean Acres on 6/24/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import UIKit

class CampaignTableViewController: UITableViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var myCampaignsButton: UIButton!
    @IBOutlet weak var addCampaignButton: UIButton!
    
    var userController: UserController?
    var user: User?
    private let campaignController = CampaignController()
    private var campaigns: [Campaign] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let userController = userController else { return }
        if userController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
        
        if let user = user {
            if user.type != "organization" {
                addCampaignButton.isHidden = true
                myCampaignsButton.isHidden = true
            }
        }
        
//        fetchCampaigns(search: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaigns.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignCell", for: indexPath) as? CampaignTableViewCell else {
            return UITableViewCell()
        }
        
        cell.campaign = campaigns[indexPath.row]
        return cell
    }

    func fetchCampaigns(search: String?) {
        campaignController.fetchCampaigns(for: search) { (result) in
            if let campaigns = try? result.get() {
                DispatchQueue.main.async {
                    self.campaigns = campaigns
                }
            } else {
                print(result)
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CampaignDetailSegue",
            let campaignDetailVC = segue.destination as? CampaignDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                campaignDetailVC.campaign = campaigns[indexPath.row]
            }
            campaignDetailVC.campaignController = campaignController
        }
    }

    
    @IBAction func myCampaignsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addCampaignButtonTapped(_ sender: Any) {
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func editCampaignButtonTapped(_ sender: Any) {
    }
    
}

extension CampaignTableViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
