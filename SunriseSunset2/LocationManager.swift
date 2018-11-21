//
//  LocationManager.swift
//  SunriseSunset2
//
//  Created by user on 24.10.18.
//  Copyright © 2018 Chorniak inc. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces

class LocationManager {
    static let shared = LocationManager()
    var placesClient = GMSPlacesClient.shared()
    
    func getLocation(completion: @escaping ((_ place: GMSPlace?, _ coordinates: CLLocationCoordinate2D?) -> Void),
                     failure: ((_ error: Error) -> Void)?) {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                failure?(error)
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    completion(place, place.coordinate)
                }
            }
        })
    }
}
