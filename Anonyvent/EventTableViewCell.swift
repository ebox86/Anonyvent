//
//  Event.swift
//  Anonyvent
//
//  Created by Evan Kohout on 11/1/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    //MARK : Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var evebtIconView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
