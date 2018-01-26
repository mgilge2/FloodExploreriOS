//
//  StoryItemDetails.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/18/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import Foundation

class StoryItemDetails: NSObject
{
    var fileName: String!
    var fileTitle: String!
    var fileCaption: String!
    
    init(fileName: String, fileTitle: String, fileCaption: String)
    {
        self.fileName = fileName
        self.fileTitle = fileTitle
        self.fileCaption = fileCaption
    }
}
