//
//  RemoveStockViewController.swift
//  Stock Note
//
//  Created by Ankit Kumar on 10/10/20.
//

import UIKit

class RemoveStockViewController: UIViewController {
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels // Replace .inline with .compact
        }
        
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()

            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short

            let strDate = dateFormatter.string(from: datePicker.date)
            print(strDate)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
