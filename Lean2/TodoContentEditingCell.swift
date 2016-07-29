//
//  TodoContentEditingCell.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/14.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit

class TodoContentEditingCell: UITableViewCell {

    @IBOutlet weak var content: UITextField!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.content.setTextPadding(7)
    }
}
