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
            searchCampaigns()
        }
    }
    var editIndexPath: IndexPath?
    
    private var campaignsFiltered: [Campaign] = []
    
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
        return campaignsFiltered.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignCell", for: indexPath) as? CampaignTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.user = user
        cell.campaign = campaignsFiltered[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CampaignDetailSegue",
            let campaignDetailVC = segue.destination as? CampaignDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                campaignDetailVC.campaign = campaignsFiltered[indexPath.row]
                print(campaignsFiltered[indexPath.row])
            }
            campaignDetailVC.campaignController = campaignController
        } else if segue.identifier == "EditCampaignSegue",
            let editCampaignVC = segue.destination as? AddEditCampaignViewController {
                guard let indexPath = editIndexPath else { return }
                editCampaignVC.campaign = campaignsFiltered[indexPath.row]
                editCampaignVC.campaignController = campaignController
//                editCampaignVC.user = user
        } else if segue.identifier == "AddCampaignSegue",
            let addCampaignVC = segue.destination as? AddEditCampaignViewController {
            print("adding campaign")
            addCampaignVC.user = user
            addCampaignVC.campaignController = campaignController
        }
    }

    
    @IBAction func myCampaignsButtonTapped(_ sender: Any) {
        showMyCampaigns()
    }
    
    private func searchCampaigns() {
        if let searchText = searchTextField.text, !searchText.isEmpty {
            campaignsFiltered = campaigns.filter({ $0.campaignName.localizedCaseInsensitiveContains(searchText) || $0.urgencyLevel.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText) || $0.location.localizedCaseInsensitiveContains(searchText)})
        } else {
            campaignsFiltered = campaigns
        }
        print("searching campaigns")
        tableView.reloadData()
        
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
                }
            } else {
                print(result)
            }
        }
    }
}

extension CampaignTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchCampaigns()
        textField.resignFirstResponder()
        return true
    }
}

extension CampaignTableViewController: CampaignTableViewCellDelegate {
    func editButtonTapped(cell: CampaignTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        editIndexPath = indexPath
    }
}
