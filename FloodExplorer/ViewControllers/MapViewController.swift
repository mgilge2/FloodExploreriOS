//
//  FirstViewController.swift
//  FloodExplorer
//
//  Created by Michael Gilge on 12/18/17.
//  Copyright © 2017 Michael Gilge. All rights reserved.
//

import UIKit
import GoogleMaps
import XLPagerTabStrip

class MapViewController: UIViewController, GMUClusterManagerDelegate, GMSMapViewDelegate, GMUClusterRendererDelegate, IndicatorInfoProvider
{
    private var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    var selectedMarker: GMSMarker?
    var infoWindow = MapInfoWindow()
    var previousZoom: Float?
    var lattitude = 47.473985
    var longitude = -118.5489564
    var startingZoom: Float = 7.0
    var customMarkerList : [CustomMapMarker]?

    private struct MapSettings
    {
        static let distance: CLLocationDistance = 650000;
        static let pitch: CGFloat = 65;
        static let heading: CLLocationDirection = 0.0;
        static let startingCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 47.473985, longitude: -118.5489564);
    }
  
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Map")
    }
    
    override func loadView()
    {
        initMap()
        selectedMarker = nil
        addImageToNavBar()
        addMenuButtonToNavBar()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Set up the cluster manager with default icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        // Generate and add random items to the cluster manager.
        generateClusterItems()
        
        // Call cluster() after items have been added to perform the clustering and rendering on map.
        clusterManager.cluster()
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        if let location = selectedMarker?.position
        {
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
        }
    }
  
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - GMUClusterManagerDelegate
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool
    {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position, zoom: mapView.camera.zoom + 1)
        mapView.animate(to: newCamera)
        infoWindow.removeFromSuperview()
        return false
    }
    
    //MARK: - Info Window
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? //markerInfoContents
    {
        return UIView()
    }

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
    
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        if (selectedMarker != nil)
        {
            guard let location = selectedMarker?.position else
            {
                print("locationMarker is nil")
                return
            }
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
            selectedMarker!.icon = #imageLiteral(resourceName: "selected_marker")
        }
        
        if position.zoom < previousZoom!
        {
          //   selectedMarker = nil
            // infoWindow.removeFromSuperview()
        }
        previousZoom = position.zoom
 
    }
    
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
    {
        if mapView.camera.zoom == previousZoom
        {
            if selectedMarker != nil
            {
                selectedMarker?.icon = #imageLiteral(resourceName: "marker")
                selectedMarker = nil
                infoWindow.removeFromSuperview()
            }
        }
    }
    
    // MARK: - GMUMapViewDelegate
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        if let poiItem = marker.userData as? CustomMapMarker
        {
            NSLog("Did tap marker for cluster item \(poiItem.name)")
            if let _ = marker.userData as? GMUCluster
            {
                //we clicked a cluster...
            }
            else
            {
                if selectedMarker != nil
                {
                    selectedMarker?.icon = #imageLiteral(resourceName: "marker")
                }
                selectedMarker = marker
                marker.icon = #imageLiteral(resourceName: "selected_marker")
                //marker.icon = GMSMarker.markerImage(with: AppSettings.MAP_PIN_SELECTED)
                
                // Needed to create the custom info window
                guard let location = selectedMarker?.position else
                {
                    print("locationMarker is nil")
                    return false
                }
                let customMarker = marker.userData as? CustomMapMarker
                self.displayInfoWindow(customMarker: customMarker!, location: location)
            }
        }
        else
        {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    
    private func displayInfoWindow(customMarker: CustomMapMarker, location: CLLocationCoordinate2D)
    {
        infoWindow.removeFromSuperview()
        infoWindow = loadNiB()
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
        
        infoWindow.titleLabel.text = customMarker.name
        infoWindow.authorLabel.text = customMarker.author
        infoWindow.storyButton.addTarget(self, action: #selector(goToStoryClicked(_:)), for: .touchUpInside)
        infoWindow.directionButton.addTarget(self, action: #selector(getDirectionsClicked(_:)), for: .touchUpInside)
        infoWindow.imageView.moa.onSuccess = { image in
            return image
        }
        infoWindow.imageView.moa.url = customMarker.getStoryImgageUrl()
        self.view.addSubview(infoWindow)
    }
    
    //toDo fix issue with marker being unselected when map is zoomed but dialog still shows....
    @objc private func getDirectionsClicked(_ sender: Any?)
    {
        if let lat = selectedMarker?.position.latitude, let long = selectedMarker?.position.longitude
        {
            //Open directions in Google Maps App if installed...
            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL))
            {
                if let url = URL(string:"comgooglemaps://?saddr=&daddr=\(String(describing: lat)),\(String(describing: long))&directionsmode=driving")

                {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            //Open directions in web if app is not installed
            else
            {
                if let url = URL(string: "https://www.google.com/maps/dir/?saddr=&daddr=\(String(describing: lat)),\(String(describing: long))")
                {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }

            }
        }
    }
    
    @objc private func goToStoryClicked(_ sender: Any?)
    {
        if(customMarkerList!.count > 1)
        {
            let vc = StoryTabViewController() //your view controller
            vc.selectedStory = selectedMarker?.userData as? CustomMapMarker
            navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            //toDo cycle pagerTabStrip back to initial starting point
            let parentViewController = self.parent! as! StoryTabViewController
            parentViewController.moveToViewController(at: 0, animated: true)
        }
    }
    
    private func initMap()
    {
        let camera = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: startingZoom)
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        mapView = GMSMapView.map(withFrame: rect, camera: camera)
        self.view = mapView
        self.previousZoom = camera.zoom
        addChangeButtonToMap()
    }
    
    func generateClusterItems()
    {
        if customMarkerList == nil
        {
            customMarkerList = OmekaCollection.shared().OmekaDataItems
        }
        for item in customMarkerList!
        {
            clusterManager.add(item)
        }
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
   
   
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker)
    {
        if selectedMarker != nil, let customMarker = selectedMarker?.userData as? CustomMapMarker, let markerToBeRendered = marker.userData as? CustomMapMarker
        {
            if markerToBeRendered.name == customMarker.name
            {
                selectedMarker = marker
                selectedMarker!.icon = #imageLiteral(resourceName: "selected_marker")
            }
        }
        else
        {
            infoWindow.removeFromSuperview()
            selectedMarker?.icon = #imageLiteral(resourceName: "marker")
            selectedMarker = nil
        }
    }

}


