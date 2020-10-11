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
    
    @IBOutlet weak var stockPicker: UIPickerView!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels // Replace .inline with .compact
        }
    }
    
    //MARK: - Date PickerView Methods
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        datePicker = sender
        print(datePicker.date)
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
        return stocks?.count ?? 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stocks?[row].name ?? "None"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(stocks?[row].name)
    }
   
}
