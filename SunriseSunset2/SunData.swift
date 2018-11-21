//
//  SunData.swift
//  SunriseSunset2
//
//  Created by user on 11/21/18.
//  Copyright © 2018 Chorniak inc. All rights reserved.
//

import Foundation

struct SunData: Codable {
    let results: Results?
    let status: String?
}

struct Results: Codable {
    let sunrise: String?
    let sunset: String?
    
    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
    }
}
