//
//  AppSettings.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/21/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import Foundation

struct AppSettings
{
    //Web addresses for REST
    static let REST_URL_ITEMS = "http://floodexplorer.org/api/items";
    static let REST_URL_FILES = "http://floodexplorer.org/api/files";
    static let REST_URL_GEOLOC = "http://floodexplorer.org/api/geolocations";
    static let REST_SIMPLE_PAGES = "http://floodexplorer.org/api/simple_pages";
    
    //Tags for JSON parsing of REST results
    static let TAG_LAT = "latitude";
    static let TAG_LONG = "longitude";
    static let TAG_ITEM = "item";
    static let TAG_ZOOM = "zoom_level";
    static let TAG_ID = "id";
    static let TAG_ELEMENT_TEXTS = "element_texts";
    static let TAG_ELEMENT_SET = "element_set";
    static let TAG_TEXT = "text";
    static let TAG_FILENAME = "filename";
    
    //Web addresses for loading images and other things...
    static let URL_IMAGES_SQUARE_THUMBNAILS = "http://floodexplorer.org//files/square_thumbnails/";
    static let URL_IMAGES_ORIGINAL = "http://floodexplorer.org//files/original/";
    static let URL_DEFAULT_IMAGE = "http://floodexplorer.com/rockhammer.png";

    //Colors for branding....
    static let TAB_BAR_COLOR = UIColor(hexString: "#176130", alpha: 1)
    static let TAB_BAR_SELECTED_COLOR = UIColor.cyan
    static let MAP_PIN_SELECTED = UIColor(hexString: "#103A46", alpha: 1)


    static let ABOUT_TEXT = "This app was written by Mike Gilge and Taptej Sidhu in collaboration with Dr. Chad Pritchard of the Eastern Washington University Geology Department."
    
    static let ABOUT_URL_ADDRESS = "http://www.floodexplorer.org"
    static let ABOUT_EMAIL_ADDRESS = "mgilge@gmail.com"
    static let ABOUT_APP_STORE_LINK = "itms-apps://itunes.apple.com/us/app/apple-store/id519094541?mt=8"
}


