//
//  StockTableViewCell.swift
//  Stock Note
//
//  Created by Ankit Kumar on 09/10/20.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    @IBOutlet weak var stockName: UILabel!
    
    @IBOutlet weak var stockQuantity: UILabel!
    @IBOutlet weak var totalStockRate: UILabel!
    @IBOutlet weak var dateUpdated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
