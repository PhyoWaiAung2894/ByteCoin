//
//  CoinManager.swift
//  ByteCoin
//
//  Created by PhyoWai Aung on 8/28/23.
//

import Foundation
protocol CoinManagerDelegate {
    func didUpdatePrice(price: String,currency: String)
    func didFailWithError(error: Error)
}
struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "970D86CD-5E0E-43D1-9835-048DEF30DBD0"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        //create URL
        let urlstring = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlstring) {
            //Create URL session
            let session = URLSession(configuration: .default)
            //Give the session a task
            
            let task = session.dataTask(with: url) {data, resopnse, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitCoinPrice = self.parseJSON(safeData){
                        let priceString = String(format: "%.1f", bitCoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            
            task.resume()
        }
    }
    func parseJSON(_ data : Data)-> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        }catch{
            delegate?.didFailWithError(error: error)
                return nil
            
        }
    }
}
