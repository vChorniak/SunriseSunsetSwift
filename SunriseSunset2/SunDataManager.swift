//
//  SunDataManager.swift
//  SunriseSunset2
//
//  Created by user on 24.10.18.
//  Copyright © 2018 Chorniak inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class SunDataManager {
    
    let apiString = "https://api.sunrise-sunset.org/json?"
    
    func getSunDataWith(cordinates: CLLocationCoordinate2D, completion: @escaping ((_ sunriseTime: String?, _ sunsetTime: String?) -> Void)) {
        
        let letCoord = cordinates.latitude
        let longCoord = cordinates.longitude
        
        Alamofire.request("\(apiString)lat=\(letCoord)&lng=\(longCoord)").responseJSON {
            response in
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonSunInfo = jsonResponse["results"]
                let sunrise = jsonSunInfo["sunrise"].stringValue
                let sunset = jsonSunInfo["sunset"].stringValue
                completion(sunrise, sunset)
            }
        }
    }
}
