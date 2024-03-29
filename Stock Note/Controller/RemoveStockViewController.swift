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
    @IBOutlet weak var quantityFillLabel: UILabel!
    @IBOutlet weak var rateFillLabel: UILabel!
    
    var stockRow: Int = 0
    var currentQuantity: Double = 0.0
    var boughtRate: Double = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemRed]
        navigationController?.navigationBar.tintColor = UIColor.systemRed
        
        quantityTextField.layer.borderWidth = 0.75
        quantityTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.04984947294, blue: 0.09696806222, alpha: 1)
        quantityTextField.layer.cornerRadius = 5
        quantityFillLabel.isHidden = true
        
        rateTextField.layer.borderWidth = 0.75
        rateTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.04984947294, blue: 0.09696806222, alpha: 1)
        rateTextField.layer.cornerRadius = 5
        rateFillLabel.isHidden = true
        
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
                    
                    if (archiveQuantity <= stocks?[stockRow].totalQuantity ?? 0.0) && (archiveQuantity != 0) {
                        
                        currentQuantity = archiveQuantity
                        print(currentQuantity)
                        for entry in realm.objects(Entry.self).filter("underStock == %@", stocks?[stockRow].name ?? "None").sorted(byKeyPath: K.realm.dateCreated_D, ascending: true) {
                            if entry.quantity <= currentQuantity {
                                //entry fully depleted
                                do {
                                    try realm.write {
                                        let currentStock = stocks?[stockRow]
                                        //print("Before: \(currentStock?.totalQuantity)")
                                        currentStock?.totalQuantity -= entry.quantity
                                        //print("After: \(currentStock?.totalQuantity)")
                                        //print("Before: \(currentStock?.totalRate)")
                                        currentStock?.totalRate -= entry.totalRate
                                        //print("After: \(currentStock?.totalRate)")
                                        currentStock?.dateUpdated_D = Date()
                                        currentStock?.dateUpdated_S = dateFormat.saveFormat(date: Date())
                                        
                                        //print("Before delete: \(currentQuantity), \(entry.quantity)")
                                        currentQuantity -= entry.quantity
                                        //print("After delete: \(currentQuantity), \(entry.quantity)")
                                        boughtRate += entry.totalRate
                                        //print("bought rate delete: \(boughtRate)")
                                        realm.delete(entry)
                                    }
                                } catch {
                                    print("Error deleting data, \(error)")
                                }
                            } else {
                                //entry updated 
                                do {
                                    try realm.write {
                                        //print("Before update: \(currentQuantity), \(entry.quantity)")
                                        entry.quantity -= currentQuantity
                                        //print("After update: \(currentQuantity), \(entry.quantity)")
                                        entry.totalRate = totalRateCalculator.totalRate(entry.individualRate, entry.quantity)
                                        let currentStock = stocks?[stockRow]
                                        currentStock?.totalQuantity -= currentQuantity
                                        currentStock?.totalRate -= totalRateCalculator.totalRate(entry.individualRate, currentQuantity)
                                        currentStock?.dateUpdated_D = Date()
                                        currentStock?.dateUpdated_S = dateFormat.saveFormat(date: Date())
                                        //print(entry.individualRate)
                                        //print(currentQuantity)
                                        boughtRate += totalRateCalculator.totalRate(entry.individualRate, currentQuantity)
                                        currentQuantity = 0.0
                                        //print("bought rate update: \(boughtRate)")
                                    }
                                } catch {
                                    print("Error updating data, \(error)")
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
                                //print("bought rate: \(boughtRate)")
                                let soldRate = totalRateCalculator.totalRate(newArchive.rateArchived, newArchive.quantityArchived)
                                //print("sold rate: \(soldRate)")
                                newArchive.percentageArchived = percentageCalculator.percentage(from: boughtRate, to: soldRate)
                                //print(newArchive.percentageArchived)
                                newArchive.colorProfitOrLoss = percentageCalculator.percentageColor(from: boughtRate, to: soldRate)
                                newArchive.dateArchived_D = datePicker.date
                                newArchive.dateArchived_S = dateFormat.saveFormat(date: datePicker.date)
                                //print(newArchive.colorProfitOrLoss)
                                
                                boughtRate = 0.0
                                self.realm.add(newArchive)
                            }
                        } catch {
                            print("Error archiving data, \(error)")
                        }
                        
                        let alert = UIAlertController(title: "Archived!", message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                            self.stockPicker.reloadAllComponents()
                            self.quantityTextField.text = ""
                            self.rateTextField.text = ""
                            self.datePicker.reloadInputViews()
                        }
                        
                        alert.addAction(action)
                        present(alert, animated: true, completion: nil)
                        
                    } else {
                        if quantityTextField.text == "0" {
                            quantityFillLabel.text = "* Quantity > 0"
                            quantityFillLabel.isHidden = false
                        } else {
                            quantityFillLabel.text = "* Insufficient stock"
                            quantityFillLabel.isHidden = false
                        }
                    }
                }
            }
        } else {
            quantityFillLabel.isHidden = false
            rateFillLabel.isHidden = false
        }
    }
    
    //MARK: - Data Manipulation Methods
    func loadPickerView() {
        stocks = realm.objects(Stock.self).sorted(byKeyPath: K.realm.dateUpdated_D, ascending: false)
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
        //print(stocks?[row].name)
    }
}
