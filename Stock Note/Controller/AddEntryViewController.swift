//
//  AddEntryViewController.swift
//  Stock Note
//
//  Created by Ankit Kumar on 10/10/20.
//

import UIKit
import RealmSwift

class AddEntryViewController: UIViewController {

    let realm = try! Realm()
    var entries: Results<Entry>?
    
    let dateFormat = DateFormat()
    let totalRateCalculator = TotalRateCalulator()
    
    var selectedStock: Stock?
 
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var quantityFillLabel: UILabel!
    @IBOutlet weak var rateFillLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationItem.title = selectedStock?.name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
//        navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.systemRed
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.systemGreen
        
        quantityTextField.layer.borderWidth = 0.75
        quantityTextField.layer.borderColor = #colorLiteral(red: 0, green: 0.7981444597, blue: 0.2795160413, alpha: 1)
        quantityTextField.layer.cornerRadius = 5
        quantityFillLabel.isHidden = true
        
        rateTextField.layer.borderWidth = 0.75
        rateTextField.layer.borderColor = #colorLiteral(red: 0, green: 0.7981444597, blue: 0.2795160413, alpha: 1)
        rateTextField.layer.cornerRadius = 5
        rateFillLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels // Replace .inline with .compact
        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        datePicker = sender
    }
   
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        if quantityTextField.text != "" && rateTextField.text != "" {
            if let quantity = quantityTextField.text, let rate = rateTextField.text, let currentStock = selectedStock {
                do {
                    try realm.write{
                        let newEntry = Entry()
                        newEntry.quantity = Double(quantity) ?? 0.0
                        newEntry.individualRate = Double(rate) ?? 0.0
                        newEntry.totalRate = totalRateCalculator.totalRate(Double(quantity) ?? 0.0, Double(rate) ?? 0.0)
                        newEntry.dateCreated_D = datePicker.date
                        newEntry.dateCreated_S = dateFormat.entryDate_SFormat(date: datePicker.date)
                        newEntry.underStock = currentStock.name
                        currentStock.entries.append(newEntry)
                        currentStock.totalQuantity += Double(quantity) ?? 0.0
                        currentStock.totalRate += totalRateCalculator.totalRate(Double(quantity) ?? 0.0, Double(rate) ?? 0.0)
                        currentStock.dateUpdated_D = Date()
                        currentStock.dateUpdated_S = dateFormat.saveFormat(date: Date())
                    }
                } catch {
                    print("Error adding new entry, \(error)")
                }
                performSegue(withIdentifier: K.segue.reloadSegue, sender: self)
            }
        } else {
            quantityFillLabel.isHidden = false
            rateFillLabel.isHidden = false
        }
    }
}
