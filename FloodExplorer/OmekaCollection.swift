//
//  OmekaCollection.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/19/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import Foundation

protocol OmekaCollectionDelegate
{
    func didFinishUpdates(finished: Bool)
}

class OmekaCollection
{
    var OmekaDataItems = [CustomMapMarker]()
    var omekaRestGeoResults: [[String: AnyObject]]
    var omekaRestItemResults: [[String: AnyObject]]
    var omekaRestFilesResults: [[String: AnyObject]]
    var omekaHomeResults: [[String: AnyObject]]
    var omekaHomeText: String!
    var delegate: OmekaCollectionDelegate?

    class func shared() -> OmekaCollection
    {
        return sharedOmekaCollection
    }

    private static var sharedOmekaCollection: OmekaCollection = {
        let omekaCollection = OmekaCollection()
        return omekaCollection
    }()
    
    private init()
    {
        omekaHomeResults = [[String: AnyObject]]()
        omekaRestItemResults = [[String: AnyObject]]()
        omekaRestFilesResults = [[String: AnyObject]]()
        omekaRestGeoResults = [[String: AnyObject]]()
        omekaHomeText = ""
        
        
        performGeoRestOperation()
    }
    

    private func buildOmekaHomeResults()
    {
        for homeObject in omekaHomeResults
        {
            if let text = homeObject[AppSettings.TAG_TEXT] as? String
            {
                omekaHomeText =  stripHTML(fromString: text)//stripHTML(fromString: text)
            }
        }
    }
    
    private func stripHTML(fromString rawString: String) -> String
    {
        let scanner: Scanner = Scanner(string: rawString)
        var text: NSString? = ""
        var convertedString = rawString
        while !scanner.isAtEnd {
            scanner.scanUpTo("<", into: nil)
            scanner.scanUpTo(">", into: &text)
            convertedString = convertedString.replacingOccurrences(of: "\(text!)>", with: "")
            convertedString = convertedString.replacingOccurrences(of: "\r\n\r\n\r\n\r\n", with: "\r\n\r\n")
            convertedString = convertedString.replacingOccurrences(of: "\r\n\r\n\r\n", with: "\r\n\r\n")

        }
        
        return convertedString
    }
    
    private func buildCustomMarkerList()
    {
        for geoObject in omekaRestGeoResults
        {
            if let latitude = geoObject[AppSettings.TAG_LAT] as? Double,
            let longitude = geoObject[AppSettings.TAG_LONG] as? Double,
            let locItem = geoObject[AppSettings.TAG_ITEM] as? [String:AnyObject],
            let zoom = geoObject[AppSettings.TAG_ZOOM] as? Double,
            let locId = locItem[AppSettings.TAG_ID] as? Int
            {
                var title = "";
                var storyText = "\t\t"
                var snippet = ""
                var resources = ""
                for itemObject in omekaRestItemResults
                {
                    if let itemElementID = itemObject[AppSettings.TAG_ID] as? Int,
                    let itemElementsTexts = itemObject[AppSettings.TAG_ELEMENT_TEXTS] as? [[String:AnyObject]]
                    {
                        var i = 0;
                        if itemElementID == locId
                        {
                            for text in itemElementsTexts
                            {
                                if i == 0
                                {
                                    title = (text[AppSettings.TAG_TEXT] as? String)!
                                }
                                else if i == 3
                                {
                                    resources += (text[AppSettings.TAG_TEXT] as? String)!
                                }
                                else
                                {
                                    let str = (text[AppSettings.TAG_TEXT] as? String)!
                                    let splitRay = str.components(separatedBy: " ")
                                    if splitRay.count <= 5
                                    {
                                        snippet = (text[AppSettings.TAG_TEXT] as? String)!
                                    }
                                    else
                                    {
                                        storyText += (text[AppSettings.TAG_TEXT] as? String)!
                                    }
                                }
                                i = i + 1
                            }
                        }
                       
                    }
                }
                storyText = storyText.replacingOccurrences(of: "\n", with: "\n\t\t")
                if resources.count > 1
                {
                    resources = "Resources: \n" + resources;
                }
                let clusterItem = CustomMapMarker(position: CLLocationCoordinate2DMake(latitude, longitude), name: title, storyText: storyText, zoom: zoom, storyResources: resources, author: snippet, id: locId)
                OmekaDataItems.append(clusterItem)
            }
        }
        addStoryItems()
    }
    
    private func addStoryItems()
    {
        for storyItem in omekaRestFilesResults
        {
            var picTitle = ""
            var textList = [String]()
            var itemTexts = ""
            if let fileName = storyItem[AppSettings.TAG_FILENAME] as? String,
            let item = storyItem[AppSettings.TAG_ITEM] as? [String:AnyObject],
            let id = item[AppSettings.TAG_ID] as? Int,
            let textsArray = storyItem[AppSettings.TAG_ELEMENT_TEXTS] as? [[String:AnyObject]]
            {
                for item in textsArray
                {
                    textList.append(item[AppSettings.TAG_TEXT] as! String)
                }
                var index = 0
                for text in textList
                {
                    if index == 0
                    {
                        picTitle = text
                    }
                    else
                    {
                        itemTexts += text
                    }
                    index = index + 1
                }
                for marker in OmekaDataItems
                {
                    if marker.id == id, fileExcluder(fileName: fileName)
                    {
                        marker.fileList.append(StoryItemDetails(fileName: fileName, fileTitle: picTitle, fileCaption: itemTexts))
                    }
                }
            }
        }
        delegate?.didFinishUpdates(finished: true)
    }
    
    private func fileExcluder(fileName: String) -> Bool
    {
        var ret = false
    
        if fileName.matches("(.*)jpeg")
        {
            ret = true;
        }
        if fileName.matches("(.*)JPG")
        {
            ret = true;
        }
        if fileName.matches("(.*)jpg")
        {
            ret = true;
        }
        if fileName.matches("(.*)png")
        {
            ret = true;
        }
        if fileName.matches("(.*)PNG")
        {
            ret = true;
        }
    
        return ret;
    }
    
    private func performGeoRestOperation()
    {
        let requestURL = NSURL(string: AppSettings.REST_URL_GEOLOC)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            do
            {

                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:AnyObject]]
                self.omekaRestGeoResults = json
                self.performHomeRestOperation()
            }
            catch
            {
                print("Error Serializing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    private func performItemRestOperation()
    {
        let requestURL = NSURL(string: AppSettings.REST_URL_ITEMS)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:AnyObject]]
                self.omekaRestItemResults = json
                self.buildCustomMarkerList()
                self.buildOmekaHomeResults()
            }
            catch
            {
                print("Error Serializing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    private func performHomeRestOperation()
    {
        let requestURL = NSURL(string: AppSettings.REST_SIMPLE_PAGES)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:AnyObject]]
                self.omekaHomeResults = json
                self.performFilesRestOperation()
            }
            catch
            {
                print("Error Serializing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    private func performFilesRestOperation()
    {
        let requestURL = NSURL(string: AppSettings.REST_URL_FILES)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:AnyObject]]
                self.omekaRestFilesResults = json
                self.performItemRestOperation()
            }
            catch
            {
                print("Error Serializing JSON: \(error)")
            }
        }
        task.resume()
    }
}

extension String
{
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
