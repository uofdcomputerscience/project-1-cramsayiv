//
//  MercuryCell.swift
//  MercuryBrowser
//
//  Created by Russell Mirabelli on 9/29/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import Foundation
import UIKit

class MercuryCell: UITableViewCell {

    @IBOutlet weak var mercuryImage: UIImageView!
    @IBOutlet weak var mercuryName: UILabel!
    @IBOutlet weak var mercuryType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
