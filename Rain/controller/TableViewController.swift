//
//  TableViewController.swift
//  Rain
//
//  Created by Ming Liang Khong on 31/5/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    var rainService = RainService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rainService.delegate = self
        let date_time = Date().ISO8601Format.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        rainService.fetchWeather(at: date_time)
        //rainService.fetchWeather(date_time: "123")
        self.tableView.register(LocationTableViewCell.nib(), forCellReuseIdentifier: LocationTableViewCell.identifier)
    }
    
    // MARK: - Table view data source
    
    var allRealtimeRainfallData: [RealtimeRainfallData] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRealtimeRainfallData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
        cell.locationLabel.text = allRealtimeRainfallData[indexPath.row].name
        
        let statusImageName = rainService.getStatusImageView(reading: allRealtimeRainfallData[indexPath.row].reading)
        
        cell.statusImageView.image = UIImage(systemName: statusImageName)
        
        return cell
    }
}

extension TableViewController: RainServiceDelegate {
    func didUpdateRealtimeRainfall(_ rainfall: RealtimeRainfall) {
        DispatchQueue.main.async {
            self.allRealtimeRainfallData = rainfall.getAllLocationData()
            self.tableView.reloadData()
        }
        
    }
    
    
}
