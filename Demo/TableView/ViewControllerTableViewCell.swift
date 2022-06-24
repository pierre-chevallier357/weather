//
//  ViewControllerTableViewCell.swift
//  Demo
//
//  Created by Pierre Chevallier on 24/06/2022.
//  Copyright © 2022 Julie Saby. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    @IBOutlet var weatherIcon: UIView!
    @IBOutlet var temperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
