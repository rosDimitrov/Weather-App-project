//
//  CityTemperaturesTableViewController.swift
//  MobileProject
//
//  Created by Rostislav Dimitrov on 5/20/15.
//  Copyright (c) 2015 Him and Her. All rights reserved.
//
import UIKit
class CityTemperaturesTableViewController: UITableViewController {
    var pinTitles:[String] = []
    var info:[String] = []
    var count = 0
    
    override func viewDidAppear(animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func updateForecast(sender: UIBarButtonItem) {
        self.tableView.reloadData()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pinTitles.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UITableViewCell
println("second")
     
        (cell.contentView.viewWithTag(10) as! UILabel).text = pinTitles[indexPath.row]
        (cell.contentView.viewWithTag(20) as! UILabel).text = info[(indexPath.row*4)+1]
        var coordinates:String = info[(indexPath.row*4)+2] + "," + info[(indexPath.row*4)+3]
        //println("\(coordinates)")
//-----------------------------------start SWIFT JSON version
//        var url = NSURL(string:"http://api.wunderground.com/api/028bea79b32f7fed/conditions/q/" + coordinates + ".json")
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in dispatch_sync(dispatch_get_main_queue(), {
//            var jsonError:NSError?
//            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as! NSDictionary
//            if let currentObservation = json["current_observation"] as? NSDictionary{
//                if let temp = currentObservation["temp_c"] as? Double{
//                    println("\(temp)")
//                }
//                if let weather = currentObservation["weather"] as? String{
//                    println("\(weather)")
//                }
//            }
//        })
//        }
//        task.resume()
//        url = nil
        //----------------------------end SWIFT JSON version
//-----------------------------------start SWIFTY JSON
            JSONManager.changeWeatherCoordinatesURL(coordinates)
            JSONManager.getWeatherData { (myData) -> Void in
                let json = JSON(data: myData)
                //println("\(json)")
                
                if let currentTemperature = json["current_observation"]["temp_c"].double{
                   println("\(currentTemperature)")
               (cell.contentView.viewWithTag(40) as! UIButton).setTitle("\(currentTemperature)", forState: UIControlState.Normal)
                }
                if let currentWeather = json["current_observation"]["weather"].string{
                    println("\(currentWeather)")
                    (cell.contentView.viewWithTag(30) as! UILabel).text = "\(currentWeather)"
                }
                if let buttonURL = json["current_observation"]["icon_url"].string{
                    println("\(buttonURL)")
                    
                    let url = NSURL(string: buttonURL)
                    println(url)
                    let data = NSData(contentsOfURL: url!)
                    cell.imageView?.image = UIImage(data: data!)
                }
                }
//------------------------------------end SWIFTY JSON
        return cell
    }
}
