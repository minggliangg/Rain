//
//  RealtimeRainfall.swift
//  Rain
//
//  Created by Ming Liang Khong on 31/5/21.
//

import Foundation

struct RealtimeRainfall: Decodable {
    
    let api_info: API_Info
    let metadata: Metadata
    let items: [Item]
    
    func getAllLocationData() -> [RealtimeRainfallData]{
        var results: [RealtimeRainfallData]
        
        results = metadata.stations.map({
            station -> RealtimeRainfallData in
            let correspondingReading = items[0].readings.filter({return $0.station_id == station.id})
            return RealtimeRainfallData(id: station.id, name: station.name, location: station.location, reading: correspondingReading[0].value)
        })
        return results
        
    }
}

struct RealtimeRainfallData {
    let id: String
    let name: String
    let location: Location
    let reading: Double
    
}

struct API_Info: Decodable {
    let status: String
}

struct Metadata: Decodable{
    let stations: [Station]
    let reading_type: String
    let reading_unit: String
}

struct Station:Decodable {
    let id: String
    let device_id: String
    let name: String
    let location: Location
}

struct Location: Decodable {
    let longitude: Double
    let latitude: Double
}

struct Item: Decodable {
    let timestamp: String
    let readings: [Reading]
}

struct Reading: Decodable {
    let station_id: String
    let value: Double
}
