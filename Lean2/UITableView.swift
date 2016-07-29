//
//  UITableView.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/17.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func removeExtraSeperators() {
        self.tableFooterView = UIView()
    }
    
    func removeTopMargin() {
        self.tableHeaderView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.01))
    }
}