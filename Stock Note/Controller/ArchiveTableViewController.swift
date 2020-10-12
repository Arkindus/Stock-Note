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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dateFormat = DateFormat()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemYellow]
        tableView.rowHeight = 98.5
        
        searchBar.autocapitalizationType = .allCharacters
        
        loadArchive()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        let tap = UIGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
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
            cell.dateArchivedLabel.text = dateFormat.loadFormat(date: archive.dateArchived_S ?? "")
            
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
        archives = realm.objects(Archive.self).sorted(byKeyPath: K.realm.dateArchived_D, ascending: false)
        tableView.reloadData()
    }
}

extension ArchiveTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = "Stock Symbol/ Date"
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        archives = realm.objects(Archive.self).filter("dateArchived_S CONTAINS[cd] %@ OR name CONTAINS[cd] %@", searchBar.text!, searchBar.text!).sorted(byKeyPath: K.realm.dateArchived_D, ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadArchive()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
