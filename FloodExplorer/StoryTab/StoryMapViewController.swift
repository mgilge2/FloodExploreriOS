//
//  StoryMapViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/19/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GoogleMaps
import MapKit


class StoryMapViewController: UIViewController, IndicatorInfoProvider, CLLocationManagerDelegate
{
    var selectedStory : CustomMapMarker?
    private var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var infoWindow = MapInfoWindow()


    override func loadView()
    {
        initMap()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Map")
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView?
    {
        displayInfoWindow(customMarker: selectedStory!, location: marker.position)
        return UIView()
    }
    
    private func initMap()
    {
        let camera = GMSCameraPosition.camera(withLatitude: selectedStory!.position.latitude, longitude: selectedStory!.position.longitude, zoom: 7.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView

        self.mapView?.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        addChangeButtonToMap()
        addMarkerToMap()
    }
    
    private func addMarkerToMap()
    {
        let position = selectedStory!.position
        let marker = GMSMarker(position: position)
        marker.title = selectedStory!.name
        marker.snippet = "Author"
        marker.map = mapView
    }
    
    //Mark: toDo make abstraction to make the functions available in both map viewcontrollers
    // MARK: Needed to create the custom info window (this is optional)
    
    func loadNiB() -> MapInfoWindow
    {
        let infoWindow = MapInfoWindow.instanceFromNib() as! MapInfoWindow
        return infoWindow
    }
    
    // MARK: Needed to create the custom info window (this is optional)
    func sizeForOffset(view: UIView) -> CGFloat
    {
        return  95.0
    }
    
    private func displayInfoWindow(customMarker: CustomMapMarker, location: CLLocationCoordinate2D)
    {
        infoWindow.removeFromSuperview()
        infoWindow = loadNiB()
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
        
        infoWindow.titleInfo.text = customMarker.name
        infoWindow.authorLabel.text = customMarker.author
        //infoWindow.buttonAction.addTarget(self, action: #selector(goToStoryClicked(_:)), for: .touchUpInside)
        //infoWindow.directionButton.addTarget(self, action: #selector(getDirectionsClicked(_:)), for: .touchUpInside)
        infoWindow.imageView.moa.onSuccess = { image in
            return image
        }
        infoWindow.imageView.moa.url = customMarker.getStoryImgageUrl()
        self.view.addSubview(infoWindow)
    }
    
    private func addChangeButtonToMap()
    {
        let btn: UIButton = UIButton(type: UIButtonType.roundedRect)
        //the following two lines allow the button to be placed in the top right, comment these and uncomment below to place in bottom center
        btn.frame = CGRect(x: view.bounds.minX, y: 10, width: 100, height: 50)
        btn.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        //btn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        btn.setTitle("Change Map", for: UIControlState.normal)
        btn.setTitleColor(UIColor.red, for: UIControlState.normal)
        
        btn.addTarget(self, action: #selector(self.changeButtonClicked), for: .touchUpInside)
        self.view.addSubview(btn)
        
        /*
         //Use autlayout to place the button at the bottom center of the view...
         btn.translatesAutoresizingMaskIntoConstraints = false
         btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
         btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
         btn.heightAnchor.constraint(equalToConstant:100).isActive = true
         btn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
         */
    }
    
    @objc func changeButtonClicked()
    {
        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Normal", style: .default, handler: {_ in
            self.mapView?.mapType = .normal
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: {_ in
            self.mapView?.mapType = .hybrid
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Satellite", style: .default, handler: {_ in
            self.mapView?.mapType = .satellite
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Terrain", style: .default, handler: {_ in
            self.mapView?.mapType = .terrain
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true, completion: nil)
    }
    
}

