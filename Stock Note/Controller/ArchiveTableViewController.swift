//
//  ArchiveTableViewController.swift
//  Stock Note
//
//  Created by Ankit Kumar on 10/10/20.
//

import UIKit
import RealmSwift

class ArchiveTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var archives: Results<Archive>?
    
    let dateFormat = DateFormat()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemYellow]
        tableView.rowHeight = 98.5
        
        loadArchive()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - TableView Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return archives?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomArchiveCell = tableView.dequeueReusableCell(withIdentifier: K.archiveCell) as! CustomArchiveCell
        
        cell.stockNameLabel.text = archives?[indexPath.row].name
        cell.quantityLabel.text = K.quantity + String(archives?[indexPath.row].quantityArchived ?? 0.0)
        cell.rateLabel.text = K.rate + String(archives?[indexPath.row].rateArchived ?? 0.0)
        cell.dateArchivedLabel.text = dateFormat.dateFormat(date: archives?[indexPath.row].dateArchived ?? Date())
        
        if archives?[indexPath.row].colorProfitOrLoss == true {
            cell.percentageLabel.text = archives?[indexPath.row].percentageArchived
            cell.percentageImageView.image = UIImage(systemName: "arrow.up.circle")
            cell.percentageImageView.tintColor = .systemGreen
        } else {
            cell.percentageLabel.text = archives?[indexPath.row].percentageArchived
            cell.percentageImageView.image = UIImage(systemName: "arrow.down.circle")
            cell.percentageImageView.tintColor = .systemRed
        }
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    func loadArchive() {
        archives = realm.objects(Archive.self).sorted(byKeyPath: "dateArchived", ascending: true)
        tableView.reloadData()
    }
}
