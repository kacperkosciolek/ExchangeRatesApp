//
//  ViewController.swift
//  ExchangeRatesApp
//
//  Created by Kacper on 11/06/2021.
//  Copyright © 2021 Kacper Kosciolek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyDate: UILabel!
    @IBOutlet weak var currencyRate: UILabel!
    @IBOutlet weak var changeButtonUI: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    
    @IBAction func changeButton(_ sender: UIButton) {
        let currentLabel = currencyLabel.text!
        currencyLabel.text = currencyRate.text!
        currencyRate.text = currentLabel
       
        ratesManager.getRates(currency: currencyLabel.text!, currency2: currencyRate.text!)
    }
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToMore", sender: self)
    }
    var ratesManager = RatesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratesManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        currencyPicker.setValue(UIColor.white, forKey: "textColor")
        configureButton()
        ratesManager.getRates(currency: currencyLabel.text!, currency2: currencyRate.text!)
        moreButton.layer.cornerRadius = 10
      
    }
   

    func configureButton(){
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 180, weight: .semibold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "arrow.2.squarepath", withConfiguration: largeConfig)

        changeButtonUI.setImage(largeBoldDoc, for: .normal)
        changeButtonUI.tintColor = .white
    }
}
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return ratesManager.currencyArray.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return ratesManager.currencyArray[row]
      }
      
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          let selectedCurrency = ratesManager.currencyArray[row]
    
          ratesManager.getRates(currency: selectedCurrency, currency2: currencyRate.text!)
      }
}
extension ViewController: RatesManagerDelegate {
    func didUptadeRates(price: String, currency: String) {
        DispatchQueue.main.async {
           self.resultLabel.text = price
           self.currencyLabel.text = currency
         
        }
    }
    func getDate(date: String) {
        DispatchQueue.main.async {
            self.currencyDate.text = date
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMore" {
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.currency = ratesManager.getCurrentValue()
            destinationVC.currency2 = ratesManager.getAnotherValue()
        }
    }
}


