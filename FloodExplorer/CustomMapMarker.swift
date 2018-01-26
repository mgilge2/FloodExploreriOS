//
//  CustomMapMarker.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/18/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import Foundation
import GoogleMaps

class CustomMapMarker: NSObject, GMUClusterItem
{
    var position: CLLocationCoordinate2D
    var name: String!
    var storyText: String!
    var zoom: Double!
    var storyResources: String!
    var fileList = [StoryItemDetails]()
    var author: String!
    var id: Int!
    
    init(position: CLLocationCoordinate2D, name: String, storyText: String, zoom: Double, storyResources: String, author: String, id: Int)
    {
        self.position = position
        self.name = name
        self.storyText = storyText
        self.zoom = zoom
        self.storyResources = storyResources
        self.author = author
        self.id = id
    }
    
    public func getStoryImgageUrl() -> String
    {
        //todo move url string to config file
        if fileList.count != 0
        {
            return AppSettings.URL_IMAGES_SQUARE_THUMBNAILS + fileList[0].fileName
        }
        else
        {
            return AppSettings.URL_DEFAULT_IMAGE
        }
    }
}
