//
//  httpConnectionHandler.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/8/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import Foundation
/*
class httpConnectionHandler {

//declare parameter as a dictionary which contains string as key and value combination.
var parameters = ["name": nametextField.text, "password": passwordTextField.text] as Dictionary<String, String>

//create the url with NSURL
let url = NSURL(string: "http://myServerName.com/api") //change the url

//create the session object
var session = NSURLSession.sharedSession()

//now create the NSMutableRequest object using the url object
let request = NSMutableURLRequest(URL: url!)
request.HTTPMethod = "POST" //set http method as POST

var err: NSError?
request.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &err) // pass dictionary to nsdata object and set it as request body

request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.addValue("application/json", forHTTPHeaderField: "Accept")

//create dataTask using the session object to send data to the server
var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
print("Response: \(response)")
var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
print("Body: \(strData)")
var err: NSError?
var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary

// Did the JSONObjectWithData constructor return an error? If so, log the error to the console
if(err != nil) {
print(err!.localizedDescription)
let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
println("Error could not parse JSON: '\(jsonStr)'")
}
else {
// The JSONObjectWithData constructor didn't return an error. But, we should still
// check and make sure that json has a value using optional binding.
if let parseJSON = json {
// Okay, the parsedJSON is here, let's get the value for 'success' out of it
var success = parseJSON["success"] as? Int
println("Succes: \(success)")
}
else {
// Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
println("Error could not parse JSON: \(jsonStr)")
}
}
})

task.resume()

}
*/