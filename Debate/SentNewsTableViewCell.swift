//
//  SentNewsTableViewCell.swift
//  Debate
//
//  Created by Cindy Zhao on 7/10/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class SentNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
