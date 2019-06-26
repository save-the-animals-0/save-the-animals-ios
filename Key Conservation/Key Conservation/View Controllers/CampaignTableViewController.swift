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
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        guard let userController = userController else { return }
//        if userController.bearer == nil {
//            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
//        }
        
        if let user = user {
            if !user.isOrg! {
                addCampaignButton.isHidden = true
                myCampaignsButton.isHidden = true
            }
        }
        
        fetchCampaigns()
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CampaignDetailSegue",
            let campaignDetailVC = segue.destination as? CampaignDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                campaignDetailVC.campaign = campaigns[indexPath.row]
            }
            campaignDetailVC.campaignController = campaignController
        } else if segue.identifier == "EditCampaignSegue",
            let editCampaignVC = segue.destination as? AddEditCampaignViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                editCampaignVC.campaign = campaigns[indexPath.row]
            }
            editCampaignVC.campaignController = campaignController
        }
    }

    
    @IBAction func myCampaignsButtonTapped(_ sender: Any) {
        showMyCampaigns()
    }
    
    @IBAction func addCampaignButtonTapped(_ sender: Any) {
        // placeholder, might not need this
    }
    
    @IBAction func editCampaignButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "EditCampaignsegue", sender: self)
    }
    
    private func searchCampaigns() {
        var filteredCampaigns: [Campaign] = []
        if let searchText = searchTextField.text {
            filteredCampaigns = campaigns.filter({ $0.campaignName.contains(searchText) || $0.urgencyLevel.contains(searchText) || $0.description.contains(searchText) || $0.location.contains(searchText)})
        }
        
        campaigns = filteredCampaigns
    }
    
    private func showMyCampaigns() {
        var filteredCampaigns: [Campaign] = []
        if let name = user?.name {
          filteredCampaigns = campaigns.filter({ $0.campaignName.contains(name) })
        }
        
        campaigns = filteredCampaigns
    }
    
    func fetchCampaigns() {
        campaignController.fetchCampaigns() { (result) in
            if let campaigns = try? result.get() {
                DispatchQueue.main.async {
                    self.campaigns = campaigns
                    print(campaigns)
                }
            } else {
                print(result)
            }
        }
    }
}

extension CampaignTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchCampaigns()
        tableView.reloadData()
    }
}
