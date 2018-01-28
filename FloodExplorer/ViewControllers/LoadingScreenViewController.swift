//
//  LoadingScreenViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/20/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController, OmekaCollectionDelegate
{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var omekaCollection: OmekaCollection?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        checkNetworkConnectionBeforeLoading()
    
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3);
        activityIndicator.color = UIColor.blue
        activityIndicator.startAnimating()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "LoadingSegue"){
            if let tabVC = segue.destination as? UITabBarController
            {
                tabVC.selectedIndex = 0
            }
        }
    }
    
    //MARK: below will replace the loading screen with the tab bar nav....
    private func loadMainNavigation()
    {
        let mainNav = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = mainNav
    }
    
    //MARK: Check that the device has a internet connection before proceeding to load data, we also should be checking to make sure that the website is available.....
    private func checkNetworkConnectionBeforeLoading()
    {
        if currentReachabilityStatus == .notReachable
        {
            let alertController = UIAlertController(title: "No Network", message: "This app requires an internet Connection!", preferredStyle: .alert)
            let retryButton = UIAlertAction(title: "Retry", style: .default, handler: retryConnection)
            let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(retryButton)
            alertController.addAction(cancelButton)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            omekaCollection = OmekaCollection.shared() //load the data from Floodexplorer.org
            omekaCollection?.delegate = self
        }
    }
    
    func retryConnection(_ action: UIAlertAction)
    {
        checkNetworkConnectionBeforeLoading()
    }
    
    func didFinishUpdates(finished: Bool)
    {
        DispatchQueue.main.async
        {
            self.activityIndicator.stopAnimating()
            self.loadMainNavigation()
        }
    }
}

