//
//  TodoContentCell.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/13.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit

class TodoContentCell: UITableViewCell {
    
    @IBOutlet weak var completedFlag: UIButton!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    var delegate:TodoContentCellProtocol?
    
    @IBAction func flipTodo(sender: UIButton) {
        self.completedFlag.selected = !self.completedFlag.selected
        
        setStrikethroughStyle(sender.selected)
        
        delegate?.updateTodoState(self, completed: completedFlag.selected)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated:Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(todo:Todo) -> TodoContentCell {
        self.content.text = todo.content
        self.completedFlag.selected = todo.completed.boolValue
        
        self.dueDate.text = DateUtils.representationTextOfDate(todo.dueDate)
        
        return self
    }
    
    private func setStrikethroughStyle(completed:Bool) {
        var textAttributes = [:]
        if completed {
            textAttributes = [NSStrikethroughStyleAttributeName:NSUnderlineStyle.StyleSingle.rawValue]
        }
        self.content.attributedText = NSMutableAttributedString(string: self.content.text!, attributes: textAttributes as [NSObject : AnyObject])
    }
}

protocol TodoContentCellProtocol {
    func updateTodoState(cell:TodoContentCell, completed:Bool)
}
