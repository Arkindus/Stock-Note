//
//  ArchiveTableViewController.swift
//  Stock Note
//
//  Created by Ankit Kumar on 10/10/20.
//

import UIKit

class ArchiveTableViewController: UITableViewController {
    
    let n: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    let arrowImage = [UIImageView(image: UIImage(systemName: "arrow.up.circle")).tintColor = UIColor.systemRed, UIImageView(image: UIImage(systemName: "arrow.down.circle"))] as [Any]
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemYellow]
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
        let cell: CustomArchiveCell = tableView.dequeueReusableCell(withIdentifier: K.archiveCell) as! CustomArchiveCell
        cell.stockNameLabel.text = n[indexPath.row]
        cell.quantityLabel.text = n[indexPath.row]
        cell.rateLabel.text = n[indexPath.row]
        cell.dateArchivedLabel.text = n[indexPath.row]
        cell.percentageLabel.text = "33%"
        cell.percentageImageView.image = UIImage(systemName: "arrow.down.circle")
        cell.percentageImageView.tintColor = .systemRed
        return cell
    }
}
