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
    @IBOutlet weak var allCampaignsButton: UIButton!
    
    private let userController = UserController()
    var user: User?
    let token: String? = KeychainWrapper.standard.string(forKey: "token")
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
        
        // check if first launch or not logged in
        if UserDefaults.isFirstLaunch() && token == nil {
            performSegue(withIdentifier: "PresentOnboarding", sender: self)
        } else if token == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        } else {
            getCurrentUser()
        }
        
        // hide table view seperator lines
        self.tableView.tableFooterView = UIView.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide org specific buttons
        if let user = user {
            if !user.isOrg! {
                addCampaignButton.isHidden = true
                myCampaignsButton.isHidden = true
                allCampaignsButton.isHidden = true
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
            addCampaignVC.user = user
            addCampaignVC.campaignController = campaignController
        } else if segue.identifier == "LoginViewModalSegue", let loginVC = segue.destination as? SignInViewController {
            loginVC.hideBackButton = true
        }
    }

    @IBAction func allCampaignsButtonTapped(_ sender: Any) {
        campaignsFiltered = campaigns
        allCampaignsButton.setTitleColor(.getBlueColor(), for: .normal)
        myCampaignsButton.setTitleColor(.black, for: .normal)
        UIView.transition(with: self.tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    @IBAction func myCampaignsButtonTapped(_ sender: Any) {
        myCampaignsButton.setTitleColor(.getBlueColor(), for: .normal)
        allCampaignsButton.setTitleColor(.black, for: .normal)
        showMyCampaigns()
    }
    
    private func searchCampaigns() {
        // filter campaigns by any available field
        if let searchText = searchTextField.text, !searchText.isEmpty {
            campaignsFiltered = campaigns.filter({ $0.campaignName.localizedCaseInsensitiveContains(searchText) || $0.urgencyLevel.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText) || $0.location.localizedCaseInsensitiveContains(searchText) || $0.species.localizedCaseInsensitiveContains(searchText)})
        } else {
            campaignsFiltered = campaigns
        }
        UIView.transition(with: self.tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    private func showMyCampaigns() {
        // show campaigns that match the org's name
        if let name = user?.name {
            campaignsFiltered = campaigns.filter({ $0.campaignName.contains(name) })
        } else {
            campaignsFiltered = campaigns
        }
        UIView.transition(with: self.tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    func fetchCampaigns() {
        campaignController.fetchCampaigns() { (result) in
            if let campaigns = try? result.get() {
                DispatchQueue.main.async {
                    self.campaigns = campaigns
                    UIView.transition(with: self.tableView,
                                      duration: 0.35,
                                      options: .transitionCrossDissolve,
                                      animations: { self.tableView.reloadData() })
                }
            } else {
                print(result)
            }
        }
    }
    
    func getCurrentUser() {
        if let token = token {
            userController.getCurrentUser(for: token) { (result) in
                if let user = try? result.get() {
                    DispatchQueue.main.async {
                        self.user = user
                            if !user.isOrg! {
                                self.addCampaignButton.isHidden = true
                                self.myCampaignsButton.isHidden = true
                                self.allCampaignsButton.isHidden = true
                            }
                    }
                } else {
                    print("Result is: \(result)")
                }
            }
        }
    }
}

// dismiss keyboard after entering search
extension CampaignTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchCampaigns()
        textField.resignFirstResponder()
        return true
    }
}

// get index path for edit buttons
extension CampaignTableViewController: CampaignTableViewCellDelegate {
    func editButtonTapped(cell: CampaignTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        editIndexPath = indexPath
    }
}
