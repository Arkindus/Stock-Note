//
//  EntryTableViewController.swift
//  Stock Note
//
//  Created by Ankit Kumar on 09/10/20.
//

import UIKit
import RealmSwift

class EntryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var entries: Results<Entry>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dateFormat = DateFormat()
    var selectedStock: Stock? {
        didSet {
            loadEntries()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = selectedStock?.name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
        tableView.rowHeight = 98.5
        
        searchBar.delegate = self
        searchBar.keyboardType = .numbersAndPunctuation
        
        tableView.tableFooterView = UIView()

        loadEntries()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomEntryCell = tableView.dequeueReusableCell(withIdentifier: K.cell.entryCell) as! CustomEntryCell
        
        if let entry = entries?[indexPath.row] {
            cell.entryQuantity?.text = K.SFormat.quantity + String(format: "%.2f", entry.quantity)
            cell.entryRate?.text = K.SFormat.rate + String(format: "%.2f", entry.individualRate)
            cell.dateCreatedLabel?.text = entry.dateCreated_S
        }
        
        return cell
    }
    
    //MARK: - Add Button Pressed
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.segue.entrySegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddEntryViewController
        destinationVC.selectedStock = selectedStock
        
    }
    
    //MARK: - Data Manipulation Methods
    func loadEntries() {
        entries = selectedStock?.entries.sorted(byKeyPath: K.realm.dateCreated_D, ascending: false)
        tableView.reloadData()
    }
    
    //MARK: - Reload Segue
    @IBAction func reloadEntryTableView(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension EntryTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = "Date"
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        entries = selectedStock?.entries.filter("dateCreated_S CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: K.realm.dateCreated_D, ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadEntries()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
