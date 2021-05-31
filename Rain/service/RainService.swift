//
//  RainService.swift
//  Rain
//
//  Created by Ming Liang Khong on 31/5/21.
//

import Foundation

protocol RainServiceDelegate {
    func didUpdateRealtimeRainfall(_ rainfall:[RealtimeRainfallData])
}

struct RainService {
    
    var delegate: RainServiceDelegate?
    
    let realtimeRainfallURL = "https://api.data.gov.sg/v1/environment/rainfall?date_time="
    
    func fetchWeather(date_time: String) {
        let urlString = realtimeRainfallURL+date_time
        performRequest(urlString)
    }
    
    func performRequest(_ urlString:String){
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error encountered: \(error)")
                    return
                }
                
                if let data = data {
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode < 200 || response.statusCode > 299 {
                            print("Error Data: \(String(data:data,encoding: .utf8) ?? "Unknown Error")")
                        } else {
                            if let realtimeRainfall = self.parseJSON(weatherData: data) {
                                self.delegate?.didUpdateRealtimeRainfall(realtimeRainfall)
                            }
                        }
                    }
                } else {
                    print("No Data")
                }
                
            }
            task.resume()
        }
        
    }
    
    func parseJSON(weatherData: Data) -> [RealtimeRainfallData]? {
        
        let decoder = JSONDecoder()
        guard let realtimeRainfall = try? decoder.decode(RealtimeRainfall.self, from: weatherData) else {
            print("An error occured while decoding Realtime Rainfall")
            return nil
        }
        return realtimeRainfall.getAllLocationData()
        
    }
}
