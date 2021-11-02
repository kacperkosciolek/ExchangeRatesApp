//
//  RatesManager.swift
//  ExchangeRatesApp
//
//  Created by Kacper on 12/05/2021.
//  Copyright © 2021 Kacper Kosciolek. All rights reserved.
//

import Foundation

protocol RatesManagerDelegate {
    func didUptadeRates(price: String, currency: String)
    func didFailWithError(error: Error)
    func getDate(date: String)
}
protocol getMoreManagerDelegate {
    func didUptadeRatesToMore(price: String)
}
class RatesManager {
    let baseURL = "https://api.exchangerate.host/latest"
    let currencyArray = ["PLN", "USD", "EUR", "GBP", "CHF", "AUD", "CAD"]
    
    var currentRate: RatesModel?
    var ratesValue: RatesValue?
    
    var delegate: RatesManagerDelegate?
    var delegate2: getMoreManagerDelegate?
    
    func getData (urlString: String, currency: String, amount: String?) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [self] (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let result = self.parseJSON(safeData) {
                        
                        for (_, value) in result {
                            let convertValue = String(format: "%.2f", value)
                            self.delegate?.didUptadeRates(price: convertValue, currency: currency)
                            self.delegate2?.didUptadeRatesToMore(price: convertValue)
                        }
                        
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func getRates(currency: String, currency2: String){
        currentRate = RatesModel(text: currency, text2: currency2)
        let urlString = "\(baseURL)?base=\(currency)&symbols=\(currency2)"
        
        getData(urlString: urlString, currency: currency, amount: nil)
    }
   
    func getRatesToMore(currency: String, currency2: String, amount: String){
        let urlString = "\(baseURL)?base=\(currency)&symbols=\(currency2)&amount=\(amount)"
       
        getData(urlString: urlString, currency: currency, amount: amount)
    }

    func parseJSON(_ data: Data) -> [String : Double]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(RatesData.self, from: data)
            let rates = decodedData.rates
            let date = decodedData.date
            delegate?.getDate(date: date)
            return rates
        } catch {
            delegate?.didFailWithError(error: error)
            return ["" : 0]
        }
    }
    func getCurrentValue() -> String {
        let rate = String(currentRate!.text)
        return rate
    }
    func getAnotherValue() -> String {
        let rate2 = String(currentRate!.text2)
        return rate2
    }
}
