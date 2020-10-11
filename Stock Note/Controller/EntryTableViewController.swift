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
    
    let dateFormat = DateFormat()
    
    var selectedStock: Stock? {
        didSet {
            loadEntries()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = selectedStock?.name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
        tableView.rowHeight = 81.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomEntryCell = tableView.dequeueReusableCell(withIdentifier: K.entryCell) as! CustomEntryCell
        
        cell.entryQuantity?.text = K.quantity + String(format: "%.2f", entries?[indexPath.row].quantity ?? 0.0)
        cell.entryRate?.text = K.rate + String(format: "%.2f", entries?[indexPath.row].individualRate ?? 0.0)
        cell.dateCreatedLabel?.text = dateFormat.dateFormat(date: entries?[indexPath.row].dateCreated ?? Date())
        
        return cell
    }
    
    //MARK: - Add Button Pressed
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.entrySegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddEntryViewController
        destinationVC.selectedStock = selectedStock
        
    }
    
    //MARK: - Data Manipulation Methods
    func loadEntries() {
        entries = selectedStock?.entries.filter("used == %@", false).sorted(byKeyPath: K.dateCreated, ascending: true)
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
