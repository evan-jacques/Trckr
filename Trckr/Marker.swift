//
//  Marker.swift
//  Trckr
//
//  Created by Evan Jacques on 2016-04-10.
//  Copyright © 2016 Evan Jacques. All rights reserved.
//

import Foundation

class Marker {
    
    var address: String?
    var id: String?
    var size: String?
    var contents: String?
    var dropoff: String?
    var pickup: String?
    var lat: String?
    var lon: String?
    
    init(){
    }
    init(address: String, id: String, size: String, contents: String, dropoff: String, pickup: String, lat: String, lon: String){
        self.address = address
        self.id = id
        self.size = size
        self.contents = contents
        self.dropoff = dropoff
        self.pickup = pickup
        self.lat = lat
        self.lon = lon
    }
}