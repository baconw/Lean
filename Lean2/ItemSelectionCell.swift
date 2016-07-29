//
//  ItemSelectionCell.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/15.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit

class ItemSelectionCell: UITableViewCell {

    @IBOutlet weak var selectionFlag: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(content:String, selected:Bool) -> ItemSelectionCell{
        self.textLabel?.text = content
        self.contentView.bringSubviewToFront(selectionFlag)
        self.config(selected)
        return self
    }
    
    func config(selected: Bool) -> ItemSelectionCell {
        if selected {
            selectionFlag.image = UIImage(named: "Check-Green")
        } else {
            selectionFlag.image = nil
        }
        return self
    }
}
