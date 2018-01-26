//
//  SecondViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/18/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var tableView: UITableView!
    var selectedStory : CustomMapMarker?
    private let kSeparatorId = 123
    private let kSeparatorHeight: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        //let color = UIColor(patternImage: UIImage(named:"seperator")!)
        //tableView.separatorColor = color
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
       // tableView.separatorStyle = .none

        //tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
       // tableView.separatorColor = UIColor(patternImage: UIImage(named: "seperator")!)

        addImageToNavBar()
        addMenuButtonToNavBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // deselect the selected row if any
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            tableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return OmekaCollection.shared().OmekaDataItems.count
    }
    
    //MARK: This is what populates the tablecells...
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! StoriesTableViewCell
            let titleTxt = OmekaCollection.shared().OmekaDataItems[indexPath.row].name
            let authorTxt = OmekaCollection.shared().OmekaDataItems[indexPath.row].author
            cell.titleLbl?.text = titleTxt
            cell.authorLbl?.text = authorTxt
            cell.thumbNail.moa.url = OmekaCollection.shared().OmekaDataItems[indexPath.row].getStoryImgageUrl()
        cell.thumbNail.clipsToBounds = true;
            cell.layoutMargins = UIEdgeInsets.zero
        
        if cell.viewWithTag(kSeparatorId) == nil //add separator only once
        {
            let separatorView = UIView(frame: CGRect(x: 0, y: cell.frame.height - kSeparatorHeight, width: cell.frame.width, height: kSeparatorHeight))
            separatorView.tag = kSeparatorId
            separatorView.backgroundColor = UIColor.blue //UIColor(patternImage: UIImage(named: "seperator")!)
            separatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
           // cell.addSubview(separatorView)
        }
        
        return cell
    }
    
    //MARK: This is what handles click events on the tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       // selectedStory = OmekaDataItems[indexPath.row]
    }
    
    //MARK: This is where we transition to the storytab
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationViewController = segue.destination as? StoryTabViewController
        {
            let selectedIndex = self.tableView.indexPath(for: sender as! UITableViewCell)
            selectedStory = OmekaCollection.shared().OmekaDataItems[selectedIndex!.row]

            destinationViewController.selectedStory = selectedStory
        }
    }
    
}



