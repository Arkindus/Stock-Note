//
//  StockTableViewController.swift
//  Stock Note
//
//  Created by Ankit Kumar on 09/10/20.
//

import UIKit
import RealmSwift

class StockTableViewController: UITableViewController {
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var totalRateLabel: UILabel!
    @IBOutlet weak var dateUpdatedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
