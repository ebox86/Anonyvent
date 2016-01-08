//
//  MapTableViewCell.swift
//  Anonyvent
//
//  Created by Evan Kohout on 1/7/16.
//  Copyright © 2016 Evan Kohout. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapTableViewCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    var locationmgr : CLLocationManager!
    var radius : Double = 1.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mapView.delegate = self
        mapView.showsUserLocation = true
        //locationmgr.delegate = self
        if (CLLocationManager.locationServicesEnabled())
        {
            locationmgr = CLLocationManager()
            locationmgr.delegate = self
            locationmgr.desiredAccuracy = kCLLocationAccuracyBest
            locationmgr.requestAlwaysAuthorization()
            locationmgr.stopUpdatingLocation()
            var currentLocation = CLLocation!()
            if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized){
                    
                    currentLocation = locationmgr.location
                    
            }
            addRadiusCircle(currentLocation)
            let initialLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            centerMapOnLocation(initialLocation)
        }

    }
    
    let regionRadius: CLLocationDistance = 2500
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 1, regionRadius * 1)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        var circle = MKCircle(centerCoordinate: location.coordinate, radius: 2440 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blueColor()
            circle.fillColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        /*
        //sets background color of cells upon selection
        let view = UIView()
        view.backgroundColor = UIColor.redColor()
        selectedBackgroundView = view
        */
    }
}