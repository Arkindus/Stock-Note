//
//  RemoveStockViewController.swift
//  Stock Note
//
//  Created by Ankit Kumar on 10/10/20.
//

import UIKit
import RealmSwift

class RemoveStockViewController: UIViewController {
    
    let realm = try! Realm()
    var stocks: Results<Stock>?
    var entries: Results<Entry>?
    
    let dateFormat = DateFormat()
    let totalRateCalculator = TotalRateCalulator()
    let percentageCalculator = PercentageCalculator()
    
    @IBOutlet weak var stockPicker: UIPickerView!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var archiveButton: UIBarButtonItem!
    
    var stockRow: Int = 0
    var boughtRate: Double = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemRed]
        navigationController?.navigationBar.tintColor = UIColor.systemRed
        
        quantityTextField.layer.borderWidth = 0.75
        quantityTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.04984947294, blue: 0.09696806222, alpha: 1)
        quantityTextField.layer.cornerRadius = 5
        
        rateTextField.layer.borderWidth = 0.75
        rateTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.04984947294, blue: 0.09696806222, alpha: 1)
        rateTextField.layer.cornerRadius = 5
        
        loadPickerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stockPicker.delegate = self
        stockPicker.dataSource = self
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels // Replace .inline with .compact
        }
    }
    
    //MARK: - Date PickerView Methods
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        datePicker = sender
        print(datePicker.date)
    }
    
    //MARK: - Archive Button Pressed
    @IBAction func archivePressed(_ sender: UIBarButtonItem) {
        //print(stocks?[stockRow ?? 0].name)
        
        if quantityTextField.text != "" && rateTextField.text != "" {
            
            if let quantity = quantityTextField.text, let rate = rateTextField.text {
                
                if let archiveQuantity = Double(quantity), let archiveRate = Double(rate) {
                    
                    if archiveQuantity <= stocks?[stockRow].totalQuantity ?? 0.0 {
                        
                        var currentQuantity: Double = archiveQuantity
                        for entry in realm.objects(Entry.self).filter("underStock == %@", stocks?[stockRow].name ?? "None").sorted(byKeyPath: "dateCreated", ascending: true) {
                            if entry.quantity <= currentQuantity {
                                do {
                                    try realm.write {
                                        let currentStock = stocks?[stockRow]
                                        currentStock?.totalQuantity -= entry.quantity
                                        currentStock?.totalRate -= entry.totalRate
                                        currentStock?.dateUpdated = Date()
                                        entry.used = true
                                        //                                        let newArchive = Archive()
                                        //                                        newArchive.name = entry.underStock ?? "None"
                                        //                                        newArchive.quantityArchived
                                        boughtRate += entry.totalRate
                                    }
                                } catch {
                                    print("Error updating stuff")
                                }
                                //print("Before: \(currentQuantity), \(entry.quantity)")
                                currentQuantity -= entry.quantity
                                //print("After: \(currentQuantity), \(entry.quantity)")
                                
                            } else {
                                do {
                                    try realm.write {
                                        //print("Before: \(entry.quantity), \(currentQuantity)")
                                        entry.quantity -= currentQuantity
                                        //print("After: \(entry.quantity), \(currentQuantity)")
                                        
                                        let currentStock = stocks?[stockRow]
                                        currentStock?.totalQuantity -= entry.quantity
                                        currentStock?.totalRate -= (entry.quantity * entry.individualRate)
                                        currentStock?.dateUpdated = Date()
                                        currentQuantity = 0.0
                                        
                                        //boughtRate += (currentQuantity * entry.individualRate)
                                        boughtRate += totalRateCalculator.totalRate(entry.individualRate, currentQuantity)
                                    }
                                } catch {
                                    print("Error updating stuff")
                                }
                                break
                            }
                        }
                        
                        do {
                            try realm.write{
                                let newArchive = Archive()
                                newArchive.name = stocks?[stockRow].name ?? "None"
                                newArchive.quantityArchived = archiveQuantity
                                newArchive.rateArchived = archiveRate
                                let totalArchiveRate = totalRateCalculator.totalRate(newArchive.rateArchived, newArchive.quantityArchived)
                                newArchive.percentageArchived = percentageCalculator.percentage(from: boughtRate, to: totalArchiveRate)
                                newArchive.colorProfitOrLoss = percentageCalculator.percentageColor(from: boughtRate, to: totalArchiveRate)
                                self.realm.add(newArchive)
                            }
                        } catch {
                            print("Error archiving data, \(error)")
                        }
                        
                        let alert = UIAlertController(title: "Successfully Archived", message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                            self.stockPicker.reloadAllComponents()
                            self.quantityTextField.text = ""
                            self.rateTextField.text = ""
                            self.datePicker.reloadInputViews()
                        }
                        
                        alert.addAction(action)
                        present(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Insufficient quantity", message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(action)
                        present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Please fill out all fields", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Data Manipulation Methods
    func loadPickerView() {
        stocks = realm.objects(Stock.self).sorted(byKeyPath: K.dateUpdated, ascending: false)
        stockPicker.reloadAllComponents()
    }
}

//MARK: - PickerView Datasource and Delegate Methods
extension RemoveStockViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let safeCount = stocks?.count {
            if safeCount != 0 {
                archiveButton.isEnabled = true
                stockPicker.isHidden = false
                return safeCount
            } else {
                archiveButton.isEnabled = false
                stockPicker.isHidden = true
                return 0
            }
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stocks?[row].name ?? "None"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stockRow = row
        print(stocks?[row].name)
    }
}
