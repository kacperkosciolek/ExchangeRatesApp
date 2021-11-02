//
//  RatesData.swift
//  ExchangeRatesApp
//
//  Created by Kacper on 12/05/2021.
//  Copyright © 2021 Kacper Kosciolek. All rights reserved.
//

import Foundation


struct RatesData: Codable {
    let rates: [String: Double]
    let base, date: String
}
