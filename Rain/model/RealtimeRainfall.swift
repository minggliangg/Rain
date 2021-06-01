//
//  RealtimeRainfall.swift
//  Rain
//
//  Created by Ming Liang Khong on 31/5/21.
//

import Foundation

struct RealtimeRainfall: Decodable {
    
    enum CodingKeys: String,CodingKey{
        case apiInfo = "api_info"
        case metadata = "metadata"
        case items = "items"
    }
    
    let apiInfo: APIInfo
    let metadata: Metadata
    let items: [Item]
    
    func getAllLocationData() -> [RealtimeRainfallData]{
        var results: [RealtimeRainfallData]
        
        results = metadata.stations.map({
            station -> RealtimeRainfallData in
            let correspondingReading = items[0].readings.filter({return $0.stationId == station.id})
            return RealtimeRainfallData(id: station.id, name: station.name.capitalized, location: station.location, reading: correspondingReading[0].value)
        })
        return results
        
    }
    
    func getNearestLocation(longitude:Double, latitude: Double) -> RealtimeRainfallData?{
        var closestDistance = -1.0
        var closestLocation: RealtimeRainfallData?
        
        let formattedData = self.getAllLocationData()
        _ = formattedData.map({realtimeRainfallData in
            let coordinateDistance = pow(realtimeRainfallData.location.latitude - latitude, 2) + pow(realtimeRainfallData.location.longitude - longitude,2)
            if closestDistance < 0 || coordinateDistance < closestDistance {
                closestDistance = coordinateDistance
                closestLocation = realtimeRainfallData
            }
             
        })
        
       return closestLocation
        
    }
}

struct RealtimeRainfallData {
    let id: String
    let name: String
    let location: Location
    let reading: Double
    
}

struct APIInfo: Decodable {
    let status: String
}

struct Metadata: Decodable{
    
    enum CodingKeys: String,CodingKey{
        case stations = "stations"
        case readingType = "reading_type"
        case readingUnit = "reading_unit"
    }
    
    let stations: [Station]
    let readingType: String
    let readingUnit: String
}

struct Station:Decodable {
    
    enum CodingKeys: String,CodingKey{
        case id = "id"
        case deviceId = "device_id"
        case name = "name"
        case location = "location"
    }
    
    let id: String
    let deviceId: String
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
    
    enum CodingKeys: String,CodingKey{
        case stationId = "station_id"
        case value = "value"
    }
    
    let stationId: String
    let value: Double
}
