//
//  MapTableViewCell.swift
//  Anonyvent
//
//  Created by Evan Kohout on 1/7/16.
//  Copyright © 2016 Evan Kohout. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
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