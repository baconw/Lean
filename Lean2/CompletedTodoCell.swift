//
//  CompletedTodoCell.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/17.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit

class CompletedTodoCell: TodoContentCell {

    //@IBOutlet weak var content: UILabel!
    @IBOutlet weak var todolist: UILabel!
    @IBOutlet weak var completedTime: UILabel!
    //@IBOutlet weak var completedFlag: UIButton!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    /*
    @IBAction func flipTodo(sender: UIButton) {
    }
    */
    
    override func config(todo:Todo) -> CompletedTodoCell {
        //println("completed todo content = \(todo.content)")
        self.completedFlag.selected = todo.completed.boolValue
        self.content.text = todo.content
        self.todolist.text = todo.todolist.content
        self.completedTime.text = DateUtils.representationCompleteTextOfDate(todo.completedTime)
        
        return self
    }

}
