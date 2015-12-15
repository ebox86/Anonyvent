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
    case StartDate = "startDate"
    case Location = "location"
    case Description = "description"
    case EventStatus = "eventStatus"
    case EventName = "eventName"
    case Id = "id"
    case EventTimestamp = "eventTimestamp"
    case UDID = "udid"
}

enum EventStatus: String {
    case Active = "active"
    case Inactive = "inactive"
    case Expired = "expired"
    case Canceled = "canceled"
    case Postponed = "postponed"
    case Rescheduled = "rescheduled"
    case Scheduled = "scheduled"
}

class EventWrapper {
    var event: Array<EventPost>?
    var count: Int?
}


class EventPost {
    var id : Int?

    var startDate : String?
    var location : String?
    var description : String?
    var eventStatus : String?
    var eventName: String?
    
    required init(json: JSON, id: Int?) {
        print(json)
        self.id = id
        self.eventName = json[EventPostFields.EventName.rawValue].stringValue
        self.startDate = json[EventPostFields.StartDate.rawValue].stringValue
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
    
    class func getMoreEvents(wrapper: EventWrapper?, completionHandler: (EventWrapper?, NSError?) -> Void) {
        guard var nextURLString = wrapper?.event else {
            completionHandler(nil, nil)
            return
        }


    }

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
                wrapper.count = json.count
                
                
                var allEvents:Array = Array<EventPost>()
                for jsonEvents in json {
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