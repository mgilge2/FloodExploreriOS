//
//  TabBarViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/24/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpTabBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpTabBar()
    {
        self.tabBar.unselectedItemTintColor = UIColor.white
        //change the top navigation bar color throughout entire app....
        UINavigationBar.appearance().barTintColor = AppSettings.TAB_BAR_COLOR
        //change the color of the tab bar throughout entire app....
        UITabBar.appearance().barTintColor = AppSettings.TAB_BAR_COLOR
        UITabBar.appearance().tintColor = AppSettings.TAB_BAR_SELECTED_COLOR
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.cyan], for:.selected)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
