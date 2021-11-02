//
//  SecondViewController.swift
//  ExchangeRatesApp
//
//  Created by Kacper on 11/06/2021.
//  Copyright © 2021 Kacper Kosciolek. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet weak var countRate: UILabel!
    @IBOutlet weak var test2: UILabel!
    
    var currency: String? 
    var currency2: String?
    var value: Double?
    
    var ratesManager = RatesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratesManager.delegate2 = self
        numberTextField.becomeFirstResponder()
        
        test.text = currency
        test2.text = currency2
        
        numberTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            view.addGestureRecognizer(tap)
    }
    @IBAction func textFieldPressed(_ sender: UITextField) {
        print(sender)
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(numberTextField.text!)

            ratesManager.getRatesToMore(currency: currency!, currency2: currency2!, amount: numberTextField.text!)
        numberTextField.resignFirstResponder()
            return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
}
extension SecondViewController: getMoreManagerDelegate {
    func didUptadeRatesToMore(price: String) {
        DispatchQueue.main.async {
           self.countRate.text = price
        }
        
    }
    
}

