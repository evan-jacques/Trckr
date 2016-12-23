//
//  ButtonsViewController.swift
//  Trckr
//
//  Created by Evan Jacques on 2016-03-31.
//  Copyright © 2016 Evan Jacques. All rights reserved.
//

import UIKit

class ButtonsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let sizeData = ["10yd", "12yd", "20yd", "30yd", "40yd", "50yd"]
    var selectedSize = 0
    let apiCall = ApiCall()
    var location = Marker()
    var switchState = 0
    var lat: Double = 0.0
    var lon: Double = 0.0
    var isEdit = false
    var editAddress = ""
    var editID = ""
    var editContents = ""
    var editDropoff = NSDate()
    var editPickup = false
    
    @IBAction func cancelButton(sender: UIButton) {
        performSegueWithIdentifier("finishedMarkerInformation", sender: nil)
    }
    @IBOutlet weak var addressInformation: UITextField!{
        didSet{
            addressInformation.text = editAddress
        }
    }
    @IBOutlet weak var idInformation: UITextField!{
        didSet {
            idInformation.text = editID
        }
    }
    @IBOutlet weak var sizeInformation: UIPickerView!
    @IBOutlet weak var pickupInformation: UISwitch! {
        didSet {
            pickupInformation.setOn(editPickup, animated: false)
            pickupInformation.addTarget(self, action: #selector(ButtonsViewController.switchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    @IBOutlet weak var contentsInformation: UITextField!{
        didSet {
            contentsInformation.text = editContents
        }
    }
    @IBOutlet weak var dropoffDateInformation: UIDatePicker! {
        didSet {
            dropoffDateInformation.setDate(editDropoff, animated: false)
        }
    }
    @IBAction func okButtonAction(sender: UIButton) {
        
        var tempContents = "N/A"
        var tempAddress = "N/A"
        
        if idInformation.text != ""{
            var tempId = idInformation.text!
            
            if contentsInformation.text != "" {
                tempContents = contentsInformation.text!
            }
            
            if addressInformation.text != "" {
                tempAddress = addressInformation.text!
            }
            
            let date = dropoffDateInformation.date
            let localDate = NSDateFormatter()
            localDate.dateStyle = NSDateFormatterStyle.ShortStyle
            localDate.timeStyle = .ShortStyle
            localDate.timeZone = NSTimeZone(abbreviation: "PST")
            localDate.dateFormat = "yyyy-MM-dd HH:mm"
            let timeString = localDate.stringFromDate(date)
            
            location.address = tempAddress
            location.id = tempId
            location.size = String(selectedSize)
            location.contents = tempContents
            location.dropoff = timeString
            location.pickup = String(switchState)
            location.lat = String(lat)
            location.lon = String(lon)
            if isEdit {
                apiCall.editLocation(location)
            }
            else {
                apiCall.addLocation(location)
            }
            
            performSegueWithIdentifier("finishedMarkerInformation", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idInformation.keyboardType = .NumberPad
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ButtonsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        sizeInformation.dataSource = self
        sizeInformation.delegate = self
        dropoffDateInformation.setDate(editDropoff, animated: false)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizeData[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSize = row
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func switchIsChanged(mySwitch: UISwitch) {
        if mySwitch.on {
            switchState = 1
        } else {
            switchState = 0
        }
    }
}
