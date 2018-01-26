//
//  StoriesTableViewCell.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/19/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit

class StoriesTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var thumbNail: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
