//
//  ViewController.swift
//  MobileProject
//
//  Created by Rostislav Dimitrov on 5/20/15.
//  Copyright (c) 2015 Him and Her. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var pinTitleTextField: UITextField!
    @IBOutlet weak var pinDescriptionTextField: UITextField!
    @IBOutlet weak var myMap: MKMapView!{
        didSet{
            var longPressRecogniser = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
            
            longPressRecogniser.minimumPressDuration = 1.0
            myMap.addGestureRecognizer(longPressRecogniser)
        }
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var manager = CLLocationManager()
    var info:[String] = []  //where the information about the Notations is kept
    var temperatures:[Double] = []
    var weatherConditions:[String] = []
    let infoKey:String = "myPins"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerSetup()
        mapSetup()
        //addVarnaAnnotation()
        
        //store the already inserted pins in the model array
        if(defaults.objectForKey(infoKey) != nil){
        info = defaults.objectForKey(infoKey) as! [String]
        }
        
        placePins()
       //println(defaults.objectForKey("myPins"))
      //defaults.removeObjectForKey("myPins")
    }
    
    func placePins(){
        if info.count > 0 {
            for var i=0;i<info.count;i+=4 {
                
                let annotation = MKPointAnnotation()
                annotation.title = info[i]
                annotation.subtitle = info[i+1]
                annotation.coordinate.latitude = (info[i+2] as NSString).doubleValue
                annotation.coordinate.longitude = (info[i+3] as NSString).doubleValue
                myMap.addAnnotation(annotation)
            }
        }
    }
    
    func handleLongPress(getstureRecognizer : UIGestureRecognizer){
        
        if getstureRecognizer.state != .Began { return }

        if(self.pinTitleTextField.text == "" || self.pinDescriptionTextField.text == ""){
            let alert = UIAlertView()
            alert.title = "Ooops, it seems like you forgot something :) "
            alert.message = "Please enter pin title and description first"
            alert.addButtonWithTitle("Got it")
            alert.show()
        }
        else{
            let touchPoint = getstureRecognizer.locationInView(self.myMap)
            let touchMapCoordinate = myMap.convertPoint(touchPoint, toCoordinateFromView: myMap)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchMapCoordinate
            annotation.title = self.pinTitleTextField.text
            annotation.subtitle = self.pinDescriptionTextField.text
            
            var title = annotation.title
            var subtitle = annotation.subtitle
            var x:Double = touchMapCoordinate.latitude
            var y:Double = touchMapCoordinate.longitude
            
            var xString:String = "\(x)"  // Convert Double to String
            var yString:String = "\(y)"
            //(xString as NSString).doubleValue CONVERT String to DOUBLE
            
            info.append(title)
            info.append(subtitle)
            info.append(xString)
            info.append(yString)
            
            //      println(info)

            defaults.setObject(info, forKey: infoKey)
            
            //println(touchMapCoordinate.longitude)
            //println(touchMapCoordinate.latitude)
            myMap.addAnnotation(annotation)
            self.pinTitleTextField.text = ""
            self.pinDescriptionTextField.text = ""
        }
    }
    
    func addVarnaAnnotation(){
        
        let location = CLLocationCoordinate2D(
            latitude: 43.2167,
            longitude: 27.9167
        )
        
        var pin = MKPointAnnotation()
        pin.coordinate = location
        pin.title = "Varna"
        pin.subtitle = "The Sea Capital of Bulgaria"
        myMap.addAnnotation(pin)
        
    }
    
    func mapSetup(){
        self.myMap.delegate = self
        myMap.showsUserLocation = true
        myMap.mapType = MKMapType.Hybrid
        
        //myMap.userLocation.location
        //to start with focus in London
        //        let span = MKCoordinateSpanMake(0.05, 0.05)
        //        let region = MKCoordinateRegion(center: location, span: span)
        //        myMap.setRegion(region, animated: true)
    }
    
    func locationManagerSetup(){
        
        manager.requestAlwaysAuthorization()
        //or (if used only when in use)
        //manager.requestWhenInUseAuthorization()
    
        if CLLocationManager.locationServicesEnabled(){
            self.manager.delegate = self
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.startUpdatingLocation()
        }
        
    }


//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        let location = locations[0] as! CLLocation
//        println("\(location)")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="showTemperature"{
            
            var toVC = segue.destinationViewController as! CityTemperaturesTableViewController
            toVC.info = self.info
            for(var i = 0;i<info.count;i+=4){
                
                toVC.pinTitles.append(info[i])
            }
        }
    }
}

