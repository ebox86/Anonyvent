//
//  EventsTableViewCell.swift
//  Anonyvent
//
//  Created by Evan Kohout on 12/18/15.
//  Copyright © 2015 Evan Kohout. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    //@IBOutlet weak var eventDetailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    /*
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configuredView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuredView()
    }
    
    func configuredView(){
        eventDetailLabel.text = "Blah"
    }
    */
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        /*
        //sets background color of cells upon selection
        let view = UIView()
        view.backgroundColor = UIColor.redColor()
        selectedBackgroundView = view
        */
    }
    
}