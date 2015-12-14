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


enum EventPostFields: String {
    case Name = "name"
    case StartDate = "startDate"
    case Location = "location"
    case Description = "description"
    case EventStatus = "eventStatus"
    case EventTitle = "eventTitle"
}

class EventWrapper {
    var event: Array<EventPost>?
    var count: Int?
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
        print(json)
        self.idNumber = id
        self.name = json[EventPostFields.Name.rawValue].stringValue
     //   self.startDate = json[EventPostFields.StartDate.rawValue].
     //   self.location = json[EventPostFields.Location.rawValue].stringValue
        self.description = json[EventPostFields.Description.rawValue].stringValue
     //   self.eventStatus = json[EventPostFields.EventStatus.rawValue].stringValue
     //   self.eventTitle = json[EventPostFields.EventTitle.rawValue].stringValue
    
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
    /*
    class func getMoreEvents(wrapper: EventWrapper?, completionHandler: (EventWrapper?, NSError?) -> Void) {
        guard var nextURLString = wrapper?.next else {
            completionHandler(nil, nil)
            return
        }


    }
*/
}
    
extension Alamofire.Request {
    func responseEventArray(completionHandler: Response<EventWrapper, NSError> -> Void) -> Self {
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
                //wrapper.next = json["next"].stringValue
                //wrapper.previous = json["previous"].stringValue
                //wrapper.count = json["count"].intValue
                
                
                var allEvents:Array = Array<EventPost>()
                for jsonEvents in json {
                    //print(jsonEvents.0)
                    //print(jsonEvents.1)
                    let newEvents = EventPost(json: jsonEvents.1, id: Int(jsonEvents.0))
                    allEvents.append(newEvents)
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