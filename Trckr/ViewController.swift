//
//  ViewController.swift
//  Trckr
//
//  Created by Evan Jacques on 2016-03-23.
//  Copyright © 2016 Evan Jacques. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    var locationManager = CLLocationManager()
    var location = CLLocation()
    let ADD_MARKER_TAG = 1234567
    let EDIT_MARKER_TAG = 1234568
    let DELETE_MARKER_TAG = 1234569
    let FILTER_TAG = 1234570
    let apiCall = ApiCall()
    var currentMarker = GMSMarker()
    let deleteMarkerButton = UIButton()
    let editMarkerButton = UIButton()
    let addMarkerButton = UIButton()
    let filterButton = UIButton()
    var filtered = false

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else
        {
            self.locationManager.startUpdatingLocation()
        }
        
        let camera : GMSCameraPosition
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            location = locationManager.location!
            camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude,
                longitude: location.coordinate.longitude, zoom: 5)
        }
        else {
            camera = GMSCameraPosition.cameraWithLatitude(49.225235,
                longitude: -123.101748, zoom: 5)
        }
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        self.view = mapView
        mapView.accessibilityElementsHidden = false
        
        addMarkerButtonSetup()
        editMarkerButtonSetup()
        deleteMarkerButtonSetup()
        filterForPickupButtonSetup()
        self.view.addSubview(addMarkerButton)
        self.view.addSubview(editMarkerButton)
        self.view.addSubview(deleteMarkerButton)
        self.view.addSubview(filterButton)
        
        
        
        
        apiCall.getLocations{
            locations in
            for location: Marker in locations
            {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(Double(location.lat!)!, Double(location.lon!)!)
                marker.title = location.id! + "\t" + location.contents! + "\t" + location.dropoff! + "\t" + location.pickup!
                switch location.size!{
                case "0":
                    marker.icon = GMSMarker.markerImageWithColor(UIColor.whiteColor())
                case "1":
                    marker.icon = GMSMarker.markerImageWithColor(UIColor.yellowColor())
                case "2":
                    marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
                default:
                    marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())

                }
                marker.map = mapView
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let subViews = self.view.subviews
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        for(var x = 0; x < subViews.count; x++ ) {
            let currentView = subViews[x]
            switch currentView.tag {
            case ADD_MARKER_TAG:
                currentView.frame = CGRectMake(0, viewHeight/50, viewWidth, viewHeight / 12)
            case EDIT_MARKER_TAG:
                currentView.frame = CGRectMake(0, viewHeight/50, viewWidth/2, viewHeight / 12)
            case DELETE_MARKER_TAG:
                currentView.frame = CGRectMake(viewWidth/2, viewHeight/50, viewWidth/2, viewHeight / 12)
            case FILTER_TAG:
                currentView.frame = CGRectMake(0,viewHeight - viewHeight/12, viewWidth/3, viewHeight/12)
            default:
                continue
            }
        }
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow: InfoWindowView = NSBundle.mainBundle().loadNibNamed("InfoWindowView", owner: self, options: nil).first! as! InfoWindowView
        var titleElements = marker.title?.characters.split{$0 == "\t"}.map(String.init)
        infoWindow.assignedId.text = titleElements![0]
        infoWindow.assignedContents.text = titleElements![1]
        infoWindow.assignedDropoff.text = titleElements![2]
        if titleElements![3] == "0"{
            infoWindow.assignedPickup.text = "✖️"
        }
        else {
            infoWindow.assignedPickup.text = "✔️"
        }
        return infoWindow
    }
    
    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        let newMarker = GMSMarker()
        newMarker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        newMarker.title = "input id" + "\t" + "input contents" + "\t" + "input dropoff" + "\t" + "input pickup"
        newMarker.map = mapView
        currentMarker = newMarker
    }
    
    func mapView(mapView: GMSMapView, didCloseInfoWindowOfMarker marker: GMSMarker) {
        editMarkerButton.hidden = true
        deleteMarkerButton.hidden = true
        addMarkerButton.hidden = false
    }
        
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        currentMarker = marker
        editMarkerButton.hidden = false
        deleteMarkerButton.hidden = false
        addMarkerButton.hidden = true
        return false
    }
    
    func addMarkerAction(sender: UIButton)
    {
        performSegueWithIdentifier("addMarker", sender: nil)
    }
    func editMarkerAction(sender: UIButton)
    {
        performSegueWithIdentifier("editMarker", sender: nil)
    }
    func filterAction(sender: UIButton){
        let tempMapView = self.view as! GMSMapView
        tempMapView.clear()
        if !filtered{
            self.filtered = true
            self.filterButton.setTitle("Show All", forState: .Normal)
            apiCall.getLocationsToPickup(){
                locations in
                for location: Marker in locations
                {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2DMake(Double(location.lat!)!, Double(location.lon!)!)
                    marker.title = location.id! + "\t" + location.contents! + "\t" + location.dropoff! + "\t" + location.pickup!
                    switch location.size!{
                    case "0":
                        marker.icon = GMSMarker.markerImageWithColor(UIColor.whiteColor())
                    case "1":
                        marker.icon = GMSMarker.markerImageWithColor(UIColor.yellowColor())
                    case "2":
                        marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
                    default:
                        marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
                        
                    }
                    marker.map = tempMapView
                }
                
            }
        }
        else {
            self.filtered = false
            self.filterButton.setTitle("Filter", forState: .Normal)
            apiCall.getLocations{
                locations in
                for location: Marker in locations
                {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2DMake(Double(location.lat!)!, Double(location.lon!)!)
                    marker.title = location.id! + "\t" + location.contents! + "\t" + location.dropoff! + "\t" + location.pickup!
                    switch location.size!{
                    case "0":
                        marker.icon = GMSMarker.markerImageWithColor(UIColor.whiteColor())
                    case "1":
                        marker.icon = GMSMarker.markerImageWithColor(UIColor.yellowColor())
                    case "2":
                        marker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
                    default:
                        marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
                        
                    }
                    marker.map = tempMapView
                }

            }
        }
    }
    func deleteMarkerAction(sender: UIButton)
    {
        
        let alertController = UIAlertController(title: "Warning!", message: "Are you sure you want to delete this marker?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            let titleElements = self.currentMarker.title?.characters.split{$0 == "\t"}.map(String.init)
            if titleElements![0] != "input id"
            {
                let id = titleElements![0]
                self.apiCall.deleteLocation(id)
                self.currentMarker.map = nil
            }
            else
            {
                self.currentMarker.map = nil
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            self.presentedViewController?.removeFromParentViewController()
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? UIViewController
        if let bvc = destination as? ButtonsViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "addMarker":
                    bvc.lat = location.coordinate.latitude
                    bvc.lon = location.coordinate.longitude
                    bvc.isEdit = false
                case "editMarker":
                    bvc.lat = currentMarker.position.latitude
                    bvc.lon = currentMarker.position.longitude
                    let titleElements = currentMarker.title?.characters.split{$0 == "\t"}.map(String.init)
                    if titleElements![0] != "input id"
                    {
                        bvc.isEdit = true
                        bvc.editID = titleElements![0]
                        bvc.editContents = titleElements![1]
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let date = dateFormatter.dateFromString(titleElements![2])
                        bvc.editDropoff = date!
                        if titleElements![3] == "0"
                        {
                            bvc.editPickup = false
                        }
                        else
                        {
                            bvc.editPickup = true
                        }
                    }
                    else
                    {
                        bvc.isEdit = false
                    }
                default:
                    bvc.lat = location.coordinate.latitude
                    bvc.lon = location.coordinate.longitude
                }
            }
        }
    }
    func addMarkerButtonSetup(){
        addMarkerButton.setTitle("Add Marker", forState: .Normal)
        addMarkerButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        addMarkerButton.backgroundColor = UIColor.greenColor()
        addMarkerButton.tag = ADD_MARKER_TAG
        addMarkerButton.addTarget(self, action: "addMarkerAction:", forControlEvents: .TouchDown)
    }
    func editMarkerButtonSetup(){
        editMarkerButton.setTitle("Edit Marker", forState: .Normal)
        editMarkerButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        editMarkerButton.backgroundColor = UIColor.yellowColor()
        editMarkerButton.tag = EDIT_MARKER_TAG
        editMarkerButton.addTarget(self, action: "editMarkerAction:", forControlEvents: .TouchDown)
        editMarkerButton.hidden = true
    }
    func deleteMarkerButtonSetup(){
        deleteMarkerButton.setTitle("Delete Marker", forState: .Normal)
        deleteMarkerButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        deleteMarkerButton.backgroundColor = UIColor.redColor()
        deleteMarkerButton.tag = DELETE_MARKER_TAG
        deleteMarkerButton.addTarget(self, action: "deleteMarkerAction:", forControlEvents: .TouchDown)
        deleteMarkerButton.hidden = true
    }
    func filterForPickupButtonSetup(){
        filterButton.setTitle("Filter", forState: .Normal)
        filterButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        filterButton.backgroundColor = UIColor.whiteColor();
        filterButton.tag = FILTER_TAG
        filterButton.addTarget(self, action: "filterAction:", forControlEvents: .TouchDown)
    }
}

