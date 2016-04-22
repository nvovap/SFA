//
//  CellForOrderTableViewCell.swift
//  Vega3
//
//  Created by Nevinniy Vladimir on 26.06.15.
//  Copyright (c) 2015 Nevinniy Vladimir. All rights reserved.
//

import UIKit

class CellForOrderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var residue: UILabel!
    
    @IBOutlet weak var quantity: UITextField!
   
    @IBOutlet weak var name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
