//
//  TodoPropertyCell.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/14.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit

class TodoPropertyCell: UITableViewCell {
    
    func config(imagePath: String, property: String, value: String?) -> TodoPropertyCell{
        self.detailTextLabel?.text = value
        self.imageView?.image = UIImage(named: imagePath)
        self.textLabel?.text = property
        return self
    }
}
