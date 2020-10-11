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
    
    let trc = TotalRateCalulator()
    
    var selectedStock: Stock?
 
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = selectedStock?.name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
//        navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.systemRed
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.systemGreen
        
        quantityTextField.layer.borderWidth = 0.75
        quantityTextField.layer.borderColor = #colorLiteral(red: 0, green: 0.7981444597, blue: 0.2795160413, alpha: 1)
        quantityTextField.layer.cornerRadius = 5
        
        rateTextField.layer.borderWidth = 0.75
        rateTextField.layer.borderColor = #colorLiteral(red: 0, green: 0.7981444597, blue: 0.2795160413, alpha: 1)
        rateTextField.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels // Replace .inline with .compact
        }
        //print(selectedStock?.name)
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
                        newEntry.totalRate = trc.totalRate(Double(quantity) ?? 0.0, Double(rate) ?? 0.0)
                        newEntry.dateCreated = datePicker.date
                        currentStock.entries.append(newEntry)
                        currentStock.totalQuantity += Double(quantity) ?? 0.0
                        currentStock.totalRate += trc.totalRate(Double(quantity) ?? 0.0, Double(rate) ?? 0.0)
                        currentStock.dateUpdated = Date()
                    }
                } catch {
                    print("Error adding new entry, \(error)")
                }
                //navigationController?.popViewController(animated: true)
                performSegue(withIdentifier: K.reloadSegue, sender: self)
            }
        } else {
            let alert = UIAlertController(title: "Please fill out all fields", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}
