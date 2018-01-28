//
//  MapInfoWindow.swift
//  GoogleMapsCustomInfoWindow
//
//  Created by Sofía Swidarowicz Andrade on 11/5/17.
//  Copyright © 2017 Sofía Swidarowicz Andrade. All rights reserved.
//

import UIKit

class MapInfoWindow: UIView
{
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var storyButton: UIButton!
    @IBOutlet weak var directionButton: UIButton!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapInfoWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
