//
//  EventPost.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/10/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class EventWrapper {
    var event: Array<EventPost>?
    var count: Int?
    var next: String?
    var previous: String?
}

enum EventPostFields: String {
    case Name = "name"
    case StartDate = "startDate"
    case Location = "location"
    case Description = "description"
    case EventStatus = "eventStatus"
    case EventTitle = "eventTitle"
}


class EventPost {
    var idNumber : Int?
    var name : String?
    var startDate : NSDate?
    var location : String?
    var description : String?
    var eventStatus : String?
    var eventTitle: String?
    
    required init(json: JSON, id: Int?) {
        self.idNumber = id
        self.name = json[EventPostFields.Name.rawValue].stringValue
     //   self.startDate = json[EventPostFields.StartDate.rawValue].
        self.location = json[EventPostFields.Location.rawValue].stringValue
        self.description = json[EventPostFields.Description.rawValue].stringValue
        self.eventStatus = json[EventPostFields.EventStatus.rawValue].stringValue
        self.eventTitle = json[EventPostFields.EventTitle.rawValue].stringValue
    
    }
    
    class func endpointForApigee() -> String {
        return "https://ebox86-test.apigee.net/anonyvent/events"
    }
    
    private class func getEventAtPath(path: String, completionHandler: (EventWrapper?, NSError?) -> Void){
        Alamofire.request(.GET, path)
            .responseEventArray { response in
                if let error = response.result.error
                {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(response.result.value, nil)
        }
    }
    
    class func getEvents(completionHandler: (EventWrapper?, NSError?) -> Void) {
        getEventAtPath(EventPost.endpointForApigee(), completionHandler: completionHandler)
    }
    
    class func getMoreEvents(wrapper: EventWrapper?, completionHandler: (EventWrapper?, NSError?) -> Void) {
        guard var nextURLString = wrapper?.next else {
            completionHandler(nil, nil)
            return
        }


    }
  
    
    
    
 /*
    func pullnParse (){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        Alamofire.request(.GET, endpoint)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    //print("Success wth JSON: \(JSON)")
                    var newArray = (JSON as! NSArray) as Array
                    var x = 0
                    for (x; x < newArray.count; x++) {
                        //print(x)
                        let dateX : NSDate = dateFormatter.dateFromString(String(newArray[x]["startDate"]!!))!
                        print(dateX)
                        let eventX = Event(title: String(newArray[x]["name"]), date: dateX, description: String(newArray[x]["description"]), icon: self.randoIcon.randomIcon(), id: String(newArray[x]["id"]))
                        self.events.append(eventX!)
                        print(self.events.count)
                    }
                    
                case .Failure(let error):
                    print("request failed with error: \(error)")
                }
                
        }
    }

}
*/
}
    
extension Alamofire.Request {
    func responseEventArray(completionHandler: Response<EventPost, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<EventWrapper, NSError> { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            guard let responseData = data else {
                let failureReason = "Array could not be serialized because input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
            
            switch result {
            case .Success(let value):
                let json = SwiftyJSON.JSON(value)
                let wrapper = EventWrapper()
                wrapper.next = json["next"].stringValue
                wrapper.previous = json["previous"].stringValue
                wrapper.count = json["count"].intValue
                
                var allEvents = [EventPost]()
                let results = json["results"]
                for jsonEvents in results {
                    print(jsonEvents.1)
                    let events = EventPost(json: jsonEvents.1, id: Int(jsonEvents.0))
                    allEvents.append(events)
                }
                wrapper.event = allEvents
                return .Success(wrapper)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer,
            completionHandler: completionHandler)
    }
}