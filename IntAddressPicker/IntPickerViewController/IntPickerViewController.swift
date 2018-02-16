//The MIT License (MIT)
//
//Copyright (c) 2018 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import GooglePlaces
import GoogleMaps
import SVProgressHUD

class IntPickerViewController: UIViewController,GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var viewTxtContainer : UIView!
    @IBOutlet var btnCurrentLocation : UIButton!
    @IBOutlet var txtAddress : UITextField!
    @IBOutlet weak var mapView : GMSMapView!
    
    var geocoder : GMSGeocoder = GMSGeocoder()
    
    @IBOutlet var btnDone : UIButton!
    
    var selectedPlace : GMSPlace?
    var selectedLocationCoordinate = LocationUtility.sharedUtility.currentLocation.coordinate
    var selectedAddress : String = ""
    var markerSelectedLocation = GMSMarker()
    
    var completion : ((CLLocationCoordinate2D?,String?) -> (Void))?
    
    //MARK: - Show Location Picker View Controller
    class func show(with rootViewController : UIViewController, coordinate: CLLocationCoordinate2D?, address : String?, completion : ((CLLocationCoordinate2D?,String?) -> (Void))?) -> Void {
        let selectLocationVC  = IntPickerViewController.init(nibName: "IntPickerViewController", bundle: nil)
        if coordinate != nil {
            selectLocationVC.selectedLocationCoordinate = coordinate!
        }
        if address != nil {
            selectLocationVC.selectedAddress = address!
        }
        
        selectLocationVC.completion = completion
        rootViewController.navigationController?.pushViewController(selectLocationVC, animated: true)
    }


    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTxtContainer.layer.borderWidth = 1
        viewTxtContainer.layer.borderColor = LocationUtility.sharedUtility.hexString("094578")!.cgColor
        viewTxtContainer.layer.masksToBounds = true
        
        mapView.delegate = self
        markerSelectedLocation.map = mapView
        
        let trimmed = selectedAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.characters.count > 0 {
            mapView(self.mapView, didLongPressAt: selectedLocationCoordinate)
        }else {
            setMarkerPosition()
        }
        
    }
    
    //MARK: - Set Marker Positions
    func setMarkerPosition() -> Void {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
        
            self.txtAddress.text = self.selectedAddress
            self.markerSelectedLocation.position = self.selectedLocationCoordinate
            self.mapView.animate(to: GMSCameraPosition.camera(withTarget: self.selectedLocationCoordinate, zoom: self.mapView.camera.zoom < 18.0 ? 18.0 : self.mapView.camera.zoom))
        })
        
    }
    //MARK: - IBAction
    @IBAction func btnBackTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDoneTapped() {
        self.completion!(selectedLocationCoordinate, selectedAddress)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearchTapped(sender : UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment  //suitable filter type
        autocompleteController.autocompleteFilter = filter
        self.present(autocompleteController, animated: true, completion: nil)
    
    }
    
    @IBAction func btnCurrentLocationTapped(sender : UIButton) {
        if LocationUtility.sharedUtility.currentLocation.coordinate.latitude == 0 && LocationUtility.sharedUtility.currentLocation.coordinate.longitude == 0 {
            let alertView = UIAlertController.init(title: "Current Location", message: "Your current location is not found. Please enable your GPS.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler:nil)
            alertView.addAction(action)
            
            self.present(alertView, animated: true, completion: nil)
        }
        else{
            mapView(self.mapView, didLongPressAt: LocationUtility.sharedUtility.currentLocation.coordinate)
        }
        
    }


    //MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }


    //MARK: - GMSAutocompleteViewControllerDelegate
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        selectedPlace = place
        selectedLocationCoordinate = place.coordinate
        selectedAddress = place.name + ", " + place.formattedAddress!
        
        self.dismiss(animated: true, completion: nil)
        setMarkerPosition()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        SVProgressHUD.show()
        geocoder.reverseGeocodeCoordinate(coordinate, completionHandler: {
            reverseGeocodeResponse ,error in
            if reverseGeocodeResponse != nil {
                let gmsAddress = (reverseGeocodeResponse! as GMSReverseGeocodeResponse).firstResult()
                let array = NSMutableArray()
                if gmsAddress?.thoroughfare != nil {
                    array.add(gmsAddress?.thoroughfare! ?? "")
                }
                if gmsAddress?.locality != nil {
                    array.add(gmsAddress?.locality! ?? "")
                }
                if gmsAddress?.subLocality != nil {
                    array.add(gmsAddress?.subLocality! ?? "")
                }
                if gmsAddress?.administrativeArea != nil {
                    array.add(gmsAddress?.administrativeArea! ?? "")
                }
                if gmsAddress?.postalCode != nil {
                    array.add(gmsAddress?.postalCode! ?? "")
                }
                if gmsAddress?.country != nil {
                    array.add(gmsAddress?.country! ?? "")
                }

                let formattedAddress = array.componentsJoined(by: ", ")
                
                self.selectedLocationCoordinate = coordinate
                self.selectedAddress = formattedAddress
                self.setMarkerPosition()
                print(formattedAddress)
            }
            SVProgressHUD.dismiss()
        })
    }
    
    
}
