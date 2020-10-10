//
//  StockTableViewController.swift
//  Stock Note
//
//  Created by Ankit Kumar on 09/10/20.
//

import UIKit
import RealmSwift

class StockTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var stocks: Results<Stock>?
    
    let dateModel = DateModel()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
        navigationController?.navigationBar.tintColor = UIColor.systemGreen
        tableView.rowHeight = 98.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStocks()
    }

    // MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomStockCell = tableView.dequeueReusableCell(withIdentifier: K.stockCell) as! CustomStockCell
        
        cell.stockNameLabel?.text = stocks?[indexPath.row].name ?? "No stocks added yet"
        cell.totalQuantityLabel?.text = K.quantity + String(format: "%.2f", stocks?[indexPath.row].totalQuantity ?? 0.0)
        cell.totalRateLabel?.text = K.rate + String(format: "%.2f", stocks?[indexPath.row].totalRate ?? 0.0)
        cell.dateUpdatedLabel?.text = dateModel.dateFormat(date: stocks?[indexPath.row].dateUpdated ?? Date())
        
        return cell
    }
   
    //MARK: - TableView Delegate Methods
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    //MARK: - Add Button
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Note!", message: "Enter the stock symbol", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Stock Symbol"
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newStock = Stock()
            newStock.name = textField.text!
            newStock.dateUpdated = Date()
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
        stocks = realm.objects(Stock.self)
        tableView.reloadData()
    }
}
