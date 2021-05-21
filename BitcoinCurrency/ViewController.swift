//
//  ViewController.swift
//  BitcoinCurrency
//
//  Created by user191019 on 18/05/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: - Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var price: UILabel!
    
    //MARK: - Variables and Constats
    let apiKey = "NTJkNDM4YjFhNmQ1NDFhMGI4YzhmYzYzYjBlMmVhNWY"
    
    let currencies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        fetchData(url: "\(baseUrl)\(currencies[0])")
    }
    
    //MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        // retorna o número de moedas para fazer a conversão.
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // retorna o título para a seleção
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        fetchData(url: "\(self.baseUrl)\(self.currencies[row])")
    }
    
    //MARK: - Requisição da API
    func fetchData(url: String){
        
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-ba-key")
        
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            if let data = data{
                
                self.parseJSON(json: data)
                //let dataString = String(data: data, encoding: .utf8)
                //print(dataString!)
            }else{
                print(error!)
            }
            
        }
        
        task.resume()
    }
    
    func parseJSON(json: Data){
        
        do{
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any]{
                
                if let askValue = json["ask"] as? NSNumber{
                
                    DispatchQueue.main.async{
                        
                        let formatter = NumberFormatter()
                        formatter.usesGroupingSeparator = true
                        formatter.numberStyle = .decimal
                        formatter.locale = Locale.init(identifier: "pt_BR")
                        
                        self.price.text = formatter.string(from: askValue as NSNumber)
                    }
                    
                    print("Success")
                }else{
                    
                    print("Error")
                }
            }
        }
        catch{
            print("error parsing json: \(error)")
        }
    }
}

