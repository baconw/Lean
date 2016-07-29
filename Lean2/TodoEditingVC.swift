//
//  TodoEditingVC.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/14.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit

class TodoEditingVC: UIViewController, UITableViewDataSource, UITableViewDelegate, DatePickerCellDelegate, ItemSelectionControllerDelegate {
    
    var creating = false
    
    @IBOutlet weak var tableView: UITableView!
    var todo:Todo?
    var hasDatePicker = false
    var todoRepository = TodoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //self.tableView.removeTopMargin()
        
        if(self.creating){
            let leftButton = UIBarButtonItem(title: Constants.LEFT_BAR_BUTTON_TITLE, style: UIBarButtonItemStyle.Plain, target: self, action: "cancelCreating")
            self.navigationItem.leftBarButtonItem = leftButton
            todo = todoRepository.createEmptyTodo()
        }
    }
    
    func cancelCreating() {
        todoRepository.deleteTodo(todo!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func itemSelected(todolist: Todolist) {
        todoRepository.moveTodo(todo!, destination: todolist)
        tableView.reloadRowsAtIndexPaths([todolistIndexPath()], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasDatePicker {
            return 4
        }
        return 3
    }
    
    func isDatePickerIndexPath(indexPath: NSIndexPath) -> Bool {
        if hasDatePicker && indexPath.row == 2 {
            return true
        }
        return false
    }
    
    func isDueDateIndexPath(indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 1 {
            return true
        }
        return false
    }
    
    func isTodolistIndexPath(indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 2 {
            return true
        }
        return false
    }
    
    func todolistIndexPath() -> NSIndexPath {
        return NSIndexPath(forRow: 2, inSection: 0)
    }
    
    
    func dueDateIndexPath() -> NSIndexPath {
        return NSIndexPath(forRow: 1, inSection: 0)
    }
    
    func datePickerIndexPath() -> NSIndexPath {
        return NSIndexPath(forRow: 2, inSection: 0)
    }
    
    func dateChanged(date: NSDate) {
        todo?.dueDate = date
        tableView.reloadRowsAtIndexPaths([dueDateIndexPath()], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isDatePickerIndexPath(indexPath) {
            return Constants.DATE_PICKER_HEIGH
        }
        return 44.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isDueDateIndexPath(indexPath){
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            hasDatePicker = !hasDatePicker
            
            tableView.beginUpdates()
            if hasDatePicker {
                tableView.insertRowsAtIndexPaths([datePickerIndexPath()], withRowAnimation: UITableViewRowAnimation.Top)
            }else{
                tableView.deleteRowsAtIndexPaths([datePickerIndexPath()], withRowAnimation: UITableViewRowAnimation.Top)
            }
            tableView.endUpdates()
        } else if isTodolistIndexPath(indexPath) {
            let todolistSelectionController = ItemSelectionController()
            todolistSelectionController.itemsForSelection = todoRepository.getAllTodolists()
            todolistSelectionController.selectedItem = todo?.todolist
            todolistSelectionController.delegate = self
            self.navigationController?.pushViewController(todolistSelectionController, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch indexPath.row {
        case 0:
            cell = todoContentCell(indexPath)
        case 1:
            cell = dueDateCell(indexPath)
        case 2:
            if hasDatePicker {
                cell = datePickerCell(indexPath)
            } else {
                cell = todolistCell(indexPath)
            }
        case 3:
            cell = todolistCell(indexPath)
        default: break
        }
        return cell
    }
    
    private func datePickerCell(indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(Constants.Date_PICKER_CELL, forIndexPath: indexPath) as! UITableViewCell
        if let date = todo?.dueDate {
            (cell as! DatePickerCell).pickerView.setDate(date, animated: true)
            (cell as! DatePickerCell).delegate = self
        }
        return cell
    }
    
    private func todoContentCell(indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(Constants.TODO_CONTENT_EDITING_CELL, forIndexPath: indexPath) as! UITableViewCell
        (cell as! TodoContentEditingCell).content.text = todo?.content
        return cell
    }
    
    private func dueDateCell(indexPath:NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(Constants.TODO_PROPERTY_CELL, forIndexPath: indexPath) as! UITableViewCell
        (cell as! TodoPropertyCell).config(Constants.TODO_DATE_IMAGE, property: Constants.TODO_DATE_LABEL, value: DateUtils.representationTextOfDate(todo?.dueDate))
        return cell
    }
    
    private func todolistCell(indexPath:NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(Constants.TODO_PROPERTY_CELL, forIndexPath: indexPath) as! UITableViewCell
        (cell as! TodoPropertyCell).config(Constants.TODO_GROUP_IMAGE, property: Constants.TODO_GROUP_LABEL, value: todo?.todolist.content)
        return cell
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == Constants.TODO_UPDATE_UNWIND_SEGUE_ID {
            return self.todoValid()
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.TODO_UPDATE_UNWIND_SEGUE_ID {
            if self.todoValid() && self.todoEditingContent() != todo?.content {
                self.todo?.content = todoEditingContent()
                todoRepository.saveContext()
            }
        }
    }
    
    private func todoValid() -> Bool {
        return !self.todoEditingContent().isEmpty
    }
    
    private func todoEditingContent() -> String {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TodoContentEditingCell
        return cell.content.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    /*
    private func todoContentChanged() -> Bool {
        return !self.todoEditingContent().isEmpty && self.todoEditingContent() != todo?.content
    }
    */
}
