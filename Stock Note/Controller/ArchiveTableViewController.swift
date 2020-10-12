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
        let cell: CustomArchiveCell = tableView.dequeueReusableCell(withIdentifier: K.cell.archiveCell) as! CustomArchiveCell
        
        if let archive = archives?[indexPath.row] {
            cell.stockNameLabel.text = archive.name
            cell.quantityLabel.text = K.SFormat.quantity + String(archive.quantityArchived)
            cell.rateLabel.text = K.SFormat.rate + String(archive.rateArchived)
            cell.dateArchivedLabel.text = dateFormat.loadFormat(date: archive.dateArchived ?? "")
            
            if archive.colorProfitOrLoss == true {
                cell.percentageLabel.text = archive.percentageArchived + "%"
                cell.percentageImageView.image = UIImage(systemName: K.realm.profit)
                cell.percentageImageView.tintColor = .systemGreen
            } else {
                cell.percentageLabel.text = archive.percentageArchived + "%"
                cell.percentageImageView.image = UIImage(systemName: K.realm.loss)
                cell.percentageImageView.tintColor = .systemRed
            }
            
        }
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    func loadArchive() {
        archives = realm.objects(Archive.self).sorted(byKeyPath: K.realm.dateArchived, ascending: false)
        tableView.reloadData()
    }
}
