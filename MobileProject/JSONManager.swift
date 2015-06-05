//
//  JSONManager.swift
//  MobileProject
//
//  Created by Rostislav Dimitrov on 5/25/15.
//  Copyright (c) 2015 Him and Her. All rights reserved.
//

import Foundation

var weatherURL = "http://api.wunderground.com/api/028bea79b32f7fed/conditions/q/"
                //37.8,-122.4.json

class JSONManager {

    class func changeWeatherCoordinatesURL(coordinates:String){
        weatherURL = weatherURL + coordinates + ".json"
                                 //37.8,-122.4
    }
    
    class func loadWeatherInfo(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        println("\(url)")
        var session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"wunderground", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "Not known error code."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
    
    class func getWeatherData(success: ((myData: NSData!) -> Void)) {
        loadWeatherInfo(NSURL(string: weatherURL)!, completion:{(data, error) -> Void in
            if let urlData = data {
                success(myData: urlData)
            }
        })
        self.clearString()
    }
    class func clearString(){
        weatherURL = "http://api.wunderground.com/api/028bea79b32f7fed/conditions/q/"
    }
}