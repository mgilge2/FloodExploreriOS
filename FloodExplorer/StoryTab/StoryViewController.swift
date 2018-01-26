//
//  StoryViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/19/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StoryViewController: UIViewController, IndicatorInfoProvider
{
    var selectedStory : CustomMapMarker!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var storyText: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        titleLabel.text = selectedStory?.name
        authorLabel.text! += " " + selectedStory!.author
        storyText.text = selectedStory?.storyText
        let resources = selectedStory.storyResources
        storyText.text? += "\n\n" + resources!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
    {
        return IndicatorInfo(title: "Story")
    }
}
