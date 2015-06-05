//
//  PinInfo.swift
//  MobileProject
//
//  Created by Rostislav Dimitrov on 5/20/15.
//  Copyright (c) 2015 Him and Her. All rights reserved.
//

import UIKit
import MapKit
class PinInfo: NSObject,MKAnnotation {
    
    var title:String
    var pinDescription:String
    var x:Double
    var y:Double
    var coordinate:CLLocationCoordinate2D
    
    init(title:String, pinDescription:String,x:Double,y:Double,coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.pinDescription = pinDescription
        self.x = x
        self.y = y
        self.coordinate = coordinate
        super.init()
    }

}
