//The MIT License (MIT)
//
//Copyright (c) 2018 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import Foundation
import CoreLocation
import CoreTelephony
import SVProgressHUD

class LocationUtility: NSObject, CLLocationManagerDelegate {

    /*
     NOTE: This class contains all the common methods
     */

    var locationManager : CLLocationManager = CLLocationManager()
    var currentLocation : CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    static let sharedUtility = LocationUtility()

    override init() {
        super.init()
        print("Initialize sharedUtility")
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 500 //Meter
        locationManager.startUpdatingLocation()
    }
    
    func initOnce() {
        self.SETUP_SVPROGRESS()
    }
    
    //MARK: - Instance Functions
    func SETUP_SVPROGRESS() {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(self.hexString("094578")!)
    }
    
    
    //MARK: - CLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            currentLocation = locations[0]
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }

    //MARK: - 
    func countryCodeOfCellularProvider() -> String {
        let countryCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode
        print(countryCode ?? "")
        return countryCode ?? ""
    }

    //MARK: - Class Functions
    class func STORY_BOARD() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard
    }
    
    //MARK: - Hex String
    func hexString(_ string: String, alpha: CGFloat = 1.0) -> UIColor? {
        var formatted = string.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        else {
            return nil
        }
    }
    
}
