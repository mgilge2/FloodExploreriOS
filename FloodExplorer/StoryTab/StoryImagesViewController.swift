//
//  StoryImagesViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/19/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StoryImagesViewController: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate
{
    var selectedStory : CustomMapMarker?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        addImageToNavBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // deselect the selected row if any
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow
        {
            tableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Images")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectedStory!.fileList.count
    }

    //MARK: This is what populates the tablecells...
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imagesCellReuseIdentifier") as! StoryItemTableViewCell
        
        let titleTxt = selectedStory?.fileList[indexPath.row].fileTitle
        cell.titleLabel?.text = titleTxt
        cell.thumbNail?.moa.url = AppSettings.URL_IMAGES_SQUARE_THUMBNAILS + selectedStory!.fileList[indexPath.row].fileName
        
        return cell
    }
    
    //MARK: This is what handles click events on the tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // selectedStory = OmekaDataItems[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "storyItemSegue", sender: cell)
    }
    
    //MARK: This is where we transition to the storytab
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationViewController = segue.destination as? StoryItemViewController
        {
            let selectedIndex = self.tableView.indexPath(for: sender as! UITableViewCell)
            let selectedStoryItem = selectedStory?.fileList[(selectedIndex?.row)!]
            destinationViewController.selectedStoryItem = selectedStoryItem
        }
    }
}
