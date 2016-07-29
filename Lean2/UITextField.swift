//
//  UITextField.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/14.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setTextLeftPadding(x: CGFloat) {
        self.leftView = UIView(frame:CGRectMake(0, 0, x, self.frame.size.height))
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    func setTextRightPadding(x: CGFloat) {
        self.rightView = UIView(frame:CGRectMake(0, 0, x, self.frame.size.height))
        self.rightViewMode = UITextFieldViewMode.Always
    }
    
    func setTextPadding(x:CGFloat) {
        setTextLeftPadding(x)
        setTextRightPadding(x)
    }
}