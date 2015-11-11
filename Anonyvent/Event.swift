//
//  Event.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/1/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import Foundation
import UIKit

class Event {
    var title: String
    var date: NSDate
    var description: String
    var icon: UIImage?
    var id: String
    
    //MARK : Initializer 
    
    init?(title: String, date: NSDate, description: String, icon: UIImage?, id: String){
        self.title = title
        self.date = date
        self.description = description
        self.icon = icon
        self.id = id
        
        if title.isEmpty {
            return nil
        }
    }
}