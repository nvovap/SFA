//
//  CellForOrderTableViewCellPrice.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 02.07.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit

class CellForOrderTableViewCellPrice: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var quantity: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
