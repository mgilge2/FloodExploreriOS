//
//  StoryViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/19/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StoryTabViewController: ButtonBarPagerTabStripViewController
{
    var selectedStory : CustomMapMarker?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        
      //  settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarItemLeftRightMargin = 0
        addImageToNavBar()
        addMenuButtonToNavBar()
        //self.buttonBarView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]
    {
        //rename these, the child1 is the storyboardID (changed in the storyboard editor...)
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child1") as? StoryViewController
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child2") as? StoryImagesViewController
        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child3") as? MapViewController//StoryMapViewController

        child_1?.selectedStory = selectedStory
        child_2?.selectedStory = selectedStory
        //child_3?.selectedStory = selectedStory
        child_3?.lattitude = (selectedStory?.position.latitude)!
        child_3?.longitude = (selectedStory?.position.longitude)!
        child_3?.startingZoom = Float((selectedStory?.zoom)!)
        let customMarkerList = [selectedStory]
        child_3?.customMarkerList = customMarkerList as? [CustomMapMarker]
        return [child_1!, child_2!, child_3!]
    }

    public func setWidthHeight()
    {
     //  self.edgesForExtendedLayout = []
    }
}


