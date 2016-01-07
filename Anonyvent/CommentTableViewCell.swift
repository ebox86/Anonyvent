//
//  CommentTableViewCell.swift
//  Anonyvent
//
//  Created by Evan Kohout on 1/4/16.
//  Copyright © 2016 Evan Kohout. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {


    @IBOutlet weak var commentLabel: UILabel!
    
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