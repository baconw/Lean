//
//  DatePickerCell.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/14.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var pickerView: UIDatePicker!
    
    var delegate:DatePickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pickerView.addTarget(self, action: "dateDidChanged", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func dateDidChanged() {
        delegate?.dateChanged(pickerView.date)
    }
}

protocol DatePickerCellDelegate {
    func dateChanged(date:NSDate)
}
