//: Playground - noun: a place where people can play

import UIKit
import SwiftyJSON
import Alamofire



var string = "2015-11-06"

let strDate = "2015-11-01T00:00:00Z" // "2015-10-06T15:42:34Z"
let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
print ( dateFormatter.dateFromString( strDate )! )
