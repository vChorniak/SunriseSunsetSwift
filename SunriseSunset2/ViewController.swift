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
    @IBOutlet weak var currentDateLabel: UILabel!
    
    
    let locationManager = CLLocationManager()
    let dateFormat = DateFormat()
    private var sunModels: [SunData] = []
    let webSunLink = "https://sunrise-sunset.org"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.startUpdatingLocation()
    }
    
    @IBAction func webSunLink(_ sender: UIButton) {
        if let url = NSURL(string: webSunLink) {
            UIApplication.shared.open(url as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([ : ]), completionHandler: nil)
        }
    }
    
    // MARK: - Location func
    
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        if Reachability.isConnected() {
            getDataForCurrentLocation()
        } else {
            self.showAlert(withTitle: "No Interner Connection", andMessage: "Please, connect to the Internet and try again.")
        }
    }
    
    func getDataForCurrentLocation() {
        self.cancelTime()
        self.adressLabel.text = "loading..."
        LocationManager.shared.getLocation(completion: {  (place, coordinates)  in
            self.locationTextLabel.text = "Location: ➤"
            self.adressLabel.text = place?.name
            self.getSunInformation(coordinate: (place?.coordinate)!)
        }) { (error) in
            self.showAlert(withTitle: "Pick Place Error", andMessage: error.localizedDescription)
            self.adressLabel.text = "Pick Place Error"
            self.cancelTime()
        }
    }
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func cancelTime() {
        self.locationTextLabel.text = " "
        self.sunriseLabel.text = "-"
        self.sunsetLabel.text = "-"
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getSunInformation(coordinate cord: CLLocationCoordinate2D) {
        NetworkManager.shared.getSunInfo(coordinates: (cord)) { [weak self] result in
            switch result {
            case .result(let models):
                self?.sunModels = [models]
                self!.sunriseLabel.text = self?.dateFormat.dateFormatter(time: (models.results?.sunrise)!)
                self?.sunsetLabel.text = self?.dateFormat.dateFormatter(time: (models.results?.sunset)!)
            case .error(let error):
                self?.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
                self?.cancelTime()
            }
        }
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        self.cancelTime()
        self.locationTextLabel.text = "Location: "
        self.adressLabel.text = place.name
        self.getSunInformation(coordinate: place.coordinate)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        self.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
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
    
    
    // MARK: - Alert functions
    
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
