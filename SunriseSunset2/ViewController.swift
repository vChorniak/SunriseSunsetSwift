//
//  ViewController.swift
//  SunriseSunset2
//
//  Created by user on 11.10.18.
//  Copyright © 2018 Chorniak inc. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var locationTextLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var sunInfo = SunDataManager()
    let webSunLink = "https://sunrise-sunset.org"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.startUpdatingLocation()
        self.adressLabel.text = "Select your option"
    }
   

    @IBAction func webSunLink(_ sender: UIButton) {
            if let url = NSURL(string: webSunLink) {
                UIApplication.shared.open(url as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([ : ]), completionHandler: nil)
        }
    }
    
    // MARK: - Location func
    
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        if Reachability.isConnected() {
            checkAndGetLocation()
        } else {
            self.adressLabel.text = "No internet connection"
            self.cancelTime()
            self.locationTextLabel.text = "Error:"
        }
    }
    
    func getCurrentLocation() {
        LocationManager.shared.getLocation { (place, coordinates) in
            self.locationTextLabel.text = "Location: ➤"
            self.adressLabel.text = place?.name
            self.sunInfo.getSunDataWith(cordinates: (place?.coordinate)!, completion: { (sunrise, sunset) in
                self.sunriseLabel.text = sunrise
                self.sunsetLabel.text = sunset
                
            })
        }
    }
    
    func checkAndGetLocation() {
        self.cancelTime()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.locationError()
            case .authorizedAlways, .authorizedWhenInUse:
                self.adressLabel.text = "loading..."
                self.getCurrentLocation()
            }
        } else {
            self.locationError()
        }
    }
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Helper functions:
    func cancelTime() {
        self.locationTextLabel.text = " "
        self.sunriseLabel.text = "-"
        self.sunsetLabel.text = "-"
    }
    
    func locationError() {
        self.locationTextLabel.text = "Error:"
        self.adressLabel.text = "location services disabled"
    }
    
    // Change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        self.locationTextLabel.text = "Location: "
        self.adressLabel.text = place.name
        sunInfo.getSunDataWith(cordinates: place.coordinate) { (sunrise, sunset) in
            self.sunriseLabel.text = sunrise
            self.sunsetLabel.text = sunset
            self.locationTextLabel.text = "Location:   "
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
