//
//  StoryItemTableViewCell.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/22/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit

class StoryItemTableViewCell: UITableViewCell
{

    @IBOutlet weak var titleLabel: UILabel!
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
