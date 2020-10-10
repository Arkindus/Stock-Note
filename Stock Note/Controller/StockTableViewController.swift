//
//  StockTableViewController.swift
//  Stock Note
//
//  Created by Ankit Kumar on 09/10/20.
//

import UIKit
import RealmSwift

class StockTableViewController: UITableViewController {
    
    let n: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
        navigationController?.navigationBar.tintColor = UIColor.systemGreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return n.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomStockCell = tableView.dequeueReusableCell(withIdentifier: K.stockCell) as! CustomStockCell
        
        cell.stockNameLabel.text = n[indexPath.row]
        cell.totalQuantityLabel.text = n[indexPath.row]
        cell.totalRateLabel.text = n[indexPath.row]
        cell.dateUpdatedLabel.text = n[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.stockSegue, sender: self)
    }
}
