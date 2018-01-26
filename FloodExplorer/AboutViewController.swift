//
//  AboutViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/28/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  MFMailComposeViewControllerDelegate
{
    @IBOutlet var storeCell: UITableViewCell!
    @IBOutlet var contactCell: UITableViewCell!
    @IBOutlet var websiteCell: UITableViewCell!
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                return contactCell
            }
            else if(indexPath.row == 1)
            {
                return websiteCell
            }
            else
            {
                return storeCell
            }
        }
        else
        {
            return contactCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch(section)
        {
        case 0:
            return "Connect with us"
        default: return ""
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:
            launchEmail()
        case 1:
            launchWebsite()
        default:
            launchAppStore()
        }
        
        //deselect item
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow
        {
            tableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addImageToNavBar()
        tableView.tableFooterView = UIView()
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func launchWebsite()
    {
        guard let url = URL(string: AppSettings.ABOUT_URL_ADDRESS) else
        {
            return //be safe
        }
        if #available(iOS 10.0, *)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            UIApplication.shared.openURL(url)
        }
    }
    
    private func launchEmail()
    {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([AppSettings.ABOUT_EMAIL_ADDRESS])
        
        self.present(mail, animated: true, completion: nil)
    }
    
    private func launchAppStore()
    {
        let url = URL(string: AppSettings.ABOUT_APP_STORE_LINK)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
