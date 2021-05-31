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
        
        rainService.fetchWeather(date_time: "2021-05-31T16%3A20%3A00")
        //rainService.fetchWeather(date_time: "123")
        self.tableView.register(LocationTableViewCell.nib(), forCellReuseIdentifier: LocationTableViewCell.identifier)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    var allRealtimeRainfallData: [RealtimeRainfallData] = []

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRealtimeRainfallData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
        cell.locationLabel.text = allRealtimeRainfallData[indexPath.row].name
        
        switch allRealtimeRainfallData[indexPath.row].reading {
        case 0..<0.21:
            cell.statusImageView.image = UIImage(systemName: "cloud.drizzle")
        case 0.21..<0.83:
            cell.statusImageView.image = UIImage(systemName: "cloud.rain")
        case 0.83... :
            cell.statusImageView.image = UIImage(systemName: "cloud.heavyrain")
        default:
            cell.statusImageView.image = UIImage(systemName: "cloud")
        }
       
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TableViewController: RainServiceDelegate {
    func didUpdateRealtimeRainfall(_ rainfall: [RealtimeRainfallData]) {
        DispatchQueue.main.async {
            self.allRealtimeRainfallData = rainfall
            self.tableView.reloadData()
        }
        
    }
    
    
}
