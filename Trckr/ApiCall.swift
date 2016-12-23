//
//  ApiCall.swift
//  Trckr
//
//  Created by Evan Jacques on 2016-04-09.
//  Copyright © 2016 Evan Jacques. All rights reserved.
//

import Foundation

class ApiCall {
    
    func addLocation(location: Marker){
        let myUrl = NSURL(string: "http://trckr-trckrwebapi.rhcloud.com/trckr/webresources/markers")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("password", forHTTPHeaderField: "token")
        print(request.valueForHTTPHeaderField("Content-type"))
        
        let address: String = location.address!
        let id: Int = Int(location.id!)!
        let size: Int = Int(location.size!)!
        let contents: String = location.contents!
        let dropoff: String = location.dropoff!
        let pickup: Int = Int(location.pickup!)!
        let lat: Double = Double(location.lat!)!
        let lon: Double = Double(location.lon!)!
        
        let jsonObject: AnyObject =
            [
                "address": address,
                "id": id,
                "size": size,
                "contents": contents,
                "dropoff": dropoff,
                "pickup": pickup,
                "lat": lat,
                "lon": lon
            ]
        let jsonString = JSONStringify(jsonObject)
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil {
                print("error: \(error)")
            }
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            print("response: \(response)")
            print("data: \(dataString)\n")
        }
        task.resume()
        
    
    }
    
    func getLocations(completionHandler: (locations: [Marker]) ->()) {
        let myUrl = NSURL(string: "http://trckr-trckrwebapi.rhcloud.com/trckr/webresources/markers")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("password", forHTTPHeaderField: "token")
        var locations: [Marker] = []
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil {
                print("error: \(error)")
            }
            print("response: \(response)\n")
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
    
            let dataObject = self.convertStringToDictionary(dataString as String)
            let locationsObject = dataObject!["marker"]
            let numberOfObjects = locationsObject!.count
            print(locationsObject)
            for (var i = 0; i < numberOfObjects; i++)
            {
                if let loc = locationsObject![i]{
                    let id = loc["id"] as! String
                    if id == "1" {
                        continue
                    }
                    let address = loc["address"] as! String
                    let size = loc["size"] as! String
                    let contents = loc["contents"] as! String
                    let pickup = loc["pickup"] as! String
                    let dropoff = loc["dropoff"] as! String
                    let lat = loc["lat"] as! String
                    let lon = loc["lon"] as! String
                    let location = Marker(address: address,id: id,size: size,contents: contents,dropoff: dropoff,pickup: pickup,lat: lat,lon: lon)
                    locations.append(location)
                }
    
            }
            completionHandler(locations: locations)
            
        }
        task.resume()
    }
    
    func getLocationsToPickup(completionHandler: (locations: [Marker]) ->()) {
        let myUrl = NSURL(string: "http://trckr-trckrwebapi.rhcloud.com/trckr/webresources/markers/1")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("password", forHTTPHeaderField: "token")
        var locations: [Marker] = []
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil {
                print("error: \(error)")
            }
            print("response: \(response)\n")
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            
            let dataObject = self.convertStringToDictionary(dataString as String)
            let locationsObject = dataObject!["marker"]
            let numberOfObjects = locationsObject!.count
            print(locationsObject)
            for (var i = 0; i < numberOfObjects; i++)
            {
                if let loc = locationsObject![i]{
                    let id = loc["id"] as! String
                    if id == "1" {
                        continue
                    }
                    let address = loc["address"] as! String
                    let size = loc["size"] as! String
                    let contents = loc["contents"] as! String
                    let pickup = loc["pickup"] as! String
                    let dropoff = loc["dropoff"] as! String
                    let lat = loc["lat"] as! String
                    let lon = loc["lon"] as! String
                    let location = Marker(address: address,id: id,size: size,contents: contents,dropoff: dropoff,pickup: pickup,lat: lat,lon: lon)
                    locations.append(location)
                }
                
            }
            completionHandler(locations: locations)
            
        }
        task.resume()
    }
    
    func editLocation(location: Marker) {
        let id: Int = Int(location.id!)!
        let myUrl = NSURL(string: "http://trckr-trckrwebapi.rhcloud.com/trckr/webresources/markers/\(id)" )
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("password", forHTTPHeaderField: "token")
        print(request.valueForHTTPHeaderField("Content-type"))
        
        let address: String = location.address!
        let size: Int = Int(location.size!)!
        let contents: String = location.contents!
        let dropoff: String = location.dropoff!
        let pickup: Int = Int(location.pickup!)!
        let lat: Double = Double(location.lat!)!
        let lon: Double = Double(location.lon!)!
        
        let jsonObject: AnyObject =
        [
            "address": address,
            "size": size,
            "contents": contents,
            "dropoff": dropoff,
            "pickup": pickup,
            "lat": lat,
            "lon": lon
        ]
        let jsonString = JSONStringify(jsonObject)
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil {
                print("error: \(error)")
            }
            else {
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print("response: \(response)")
                print("data: \(dataString)\n")
            }
        }
        task.resume()

    }
    
    func deleteLocation(id: String) {
        let myUrl = NSURL(string: "http://trckr-trckrwebapi.rhcloud.com/trckr/webresources/markers/\(id)" )
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "Delete"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("password", forHTTPHeaderField: "token")
        print(request.valueForHTTPHeaderField("Content-type"))
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil {
                print("error: \(error)")
            }
            else {
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                print("response: \(response)")
                print("data: \(dataString)\n")
            }
        }
        task.resume()


    }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        
        
        if NSJSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }catch {
                
                print("error")
            }
            
        }
        return ""
        
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}