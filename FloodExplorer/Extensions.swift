//
//  Extensions.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 1/4/18.
//  Copyright © 2018 Michael Gilge. All rights reserved.
//

import Foundation
import AZDropdownMenu
import GoogleMaps
import SystemConfiguration


extension UIViewController
{
    private struct CustomProperties
    {
        static let dataSource = [AZDropdownMenuItemData(title:"About the App", icon:UIImage(imageLiteralResourceName: "rockhammer"))]
        static let titles = ["Action 1", "Action 2", "Action 3"]
        static let menu = AZDropdownMenu(dataSource: dataSource)
    }
    
    func addImageToNavBar()
    {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 44))
        var titleImageView = UIImageView(image: UIImage(named: "flood_explorer_horiz"))
        titleImageView.frame = CGRect(x: 0,y: 0,width: titleView.frame.width,height: titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
        //below will get rid of the back text on the back button
        navigationItem.title = ""
    }
    
    func addMenuButtonToNavBar()
    {
        var image = UIImage(named: "ic_more_vert")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(displayMenu))
        CustomProperties.menu.itemAlignment = .center
    }
    
    func displayAboutPage()
    {
        if let vc = Bundle.main.loadNibNamed("AboutView", owner: nil, options: nil)?.first as? AboutViewController {
            //self.present(vc, animated: true, completion: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        /*
         let controller = AboutViewController(nibName: "AboutView", bundle: nil)
         
         //  self.customPresentViewController(CustomProperties.presenter, viewController: controller, animated: true, completion: nil)
         self.present(controller, animated: true, completion: nil)
         
         */
        
    }
    
    @objc func displayMenu()
    {
        if (CustomProperties.menu.isDescendant(of: self.view) == true)
        {
            CustomProperties.menu.hideMenu()
        }
        else
        {
            //CustomProperties.menu.showMenuFromView((navigationController?.view)!)
            CustomProperties.menu.showMenuFromView(self.view)
        }
        CustomProperties.menu.cellTapHandler = { [weak self] (indexPath: IndexPath) -> Void in
            self?.displayAboutPage()
        }
        
        
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

protocol Utilities {
}

extension NSObject:Utilities
{
    
    enum ReachabilityStatus
    {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus
    {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress,{
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1)
            {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else
        {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false
        {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true
        {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false
        {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false
        {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else
        {
            return .notReachable
        }
    }
    
}
