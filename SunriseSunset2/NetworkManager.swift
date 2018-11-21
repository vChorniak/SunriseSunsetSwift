//
//  NetworkManager.swift
//  SunriseSunset2
//
//  Created by user on 11/21/18.
//  Copyright © 2018 Chorniak inc. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

final class NetworkManager {
    
    enum NetworkError: Error {
        case unknown
    }
    
    enum ExchangeRateResponce {
        case result(SunData)
        case error(Error)
    }
    
    static let shared = NetworkManager()
    private init() {}
    
    func getSunInfo(coordinates: CLLocationCoordinate2D, completion: @escaping (ExchangeRateResponce) -> ()) {
        
        let lat = coordinates.latitude
        let long = coordinates.longitude
        
        Alamofire.request("https://api.sunrise-sunset.org/json?lat=\(lat)&lng=\(long)&formatted=0").responseJSON { response in
            guard let data = response.data else {
                completion(.error(response.error ?? NetworkError.unknown))
                return
            }
            do {
                let results = try JSONDecoder().decode(SunData.self, from: data)
                completion(.result(results))
                print(results)
            } catch {
                completion(.error(error))
            }
        }
    }
}

