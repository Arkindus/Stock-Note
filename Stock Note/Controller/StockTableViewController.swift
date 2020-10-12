//
//  StockTableViewController.swift
//  Stock Note
//
//  Created by Ankit Kumar on 09/10/20.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

class StockTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var stocks: Results<Stock>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dateFormat = DateFormat()
    let pc = PercentageCalculator()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
        navigationController?.navigationBar.tintColor = UIColor.systemGreen
        tableView.rowHeight = 98.5
        
        searchBar.delegate = self
        searchBar.autocapitalizationType = .allCharacters
        
        tableView.tableFooterView = UIView()
        
        loadStocks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomStockCell = tableView.dequeueReusableCell(withIdentifier: K.cell.stockCell) as! CustomStockCell
        
        if let stock = stocks?[indexPath.row] {
            cell.stockNameLabel?.text = stock.name
            cell.totalQuantityLabel?.text = K.SFormat.quantity + String(format: "%.2f", stock.totalQuantity)
            cell.totalRateLabel?.text = K.SFormat.rate + String(format: "%.2f", stock.totalRate)
            cell.dateUpdatedLabel?.text = dateFormat.loadFormat(date: stock.dateUpdated_S ?? "")
        }
        
        return cell
    }
   
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segue.stockSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EntryTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedStock = stocks?[indexPath.row]
        }
    }
    
    //MARK: - Add Button Pressed
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Note!", message: "Enter the stock symbol", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.autocapitalizationType = .allCharacters
            alertTextField.placeholder = "Stock Symbol"
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newStock = Stock()
            newStock.name = textField.text!
            newStock.dateUpdated_D = Date()
            newStock.dateUpdated_S = self.dateFormat.saveFormat(date: Date())
            self.saveStock(newStock)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func saveStock(_ stock: Stock) {
        do {
            try realm.write {
                realm.add(stock)
            }
        } catch {
            print("Error adding stock, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadStocks() {
        stocks = realm.objects(Stock.self).sorted(byKeyPath: K.realm.dateUpdated_D, ascending: false)
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate
extension StockTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = "Stock Symbol"
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        stocks = realm.objects(Stock.self).filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: K.realm.dateUpdated_D, ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadStocks()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
