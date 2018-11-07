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
        
        Alamofire.request("\(apiString)lat=\(letCoord)&lng=\(longCoord)&formatted=0").responseJSON {
            response in
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonSunInfo = jsonResponse["results"]
                var sunrise = jsonSunInfo["sunrise"].stringValue
                var sunset = jsonSunInfo["sunset"].stringValue
                
                sunrise = self.dateFormatter(time: sunrise)
                sunset = self.dateFormatter(time: sunset)
                
                completion(sunrise, sunset)
            }
        }
    }
    
    func dateFormatter(time: String) -> String {
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: time)!
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
