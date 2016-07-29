//
//  TodosTVC.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/13.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit

class TodosTVC: UITableViewController,TodoContentCellProtocol {
    
    var todolists:[Todolist]!
    let TODO_CONTENT_CELL_ID = "TODO_CONTENT_CELL_ID"
    
    var todoRepository = TodoRepository()
    
    @IBAction func todoUpdated(segue: UIStoryboardSegue){
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        todolists = todoRepository.getAllTodolists()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return todolists!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoRepository.getTodoOfTodolist(todolists[section]).count
    }
    
    func getTodo(indexPath: NSIndexPath) -> Todo {
        var todos = todoRepository.getTodoOfTodolist(todolists[indexPath.section])
        
        /*var todos = todolists[indexPath.section].todos.allObjects
        todos.sorted {
            ($0 as! Todo).order.doubleValue < ($1 as! Todo).order.doubleValue
        }
        return todos[indexPath.row] as! Todo
*/
        return todos[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TODO_CONTENT_CELL_ID,forIndexPath: indexPath) as! TodoContentCell
        //cell.content.text = todolists![indexPath.section].todos[indexPath.row].content
        cell.config(getTodo(indexPath))
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todolists![section].content
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func updateTodoState(cell: TodoContentCell, completed: Bool) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        let todo = getTodo(indexPath)
        if(completed){
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            todoRepository.completeTodo(todo)
            tableView.endUpdates()
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.COMPLETE_TODO_NOTIFICATION, object: self, userInfo: ["Todo" : todo])
            //println("\(todo.content) is updated to \(todo.completed)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case Constants.TODO_DETAILS_SEGUE_ID:
                let controller = segue.destinationViewController as! TodoEditingVC
                let cell = sender as! UITableViewCell
                let indexPath = tableView.indexPathForCell(cell)!
                controller.todo = getTodo(indexPath)
            case Constants.CREATING_TODO_SEGUE_ID:
                let controller = segue.destinationViewController as! TodoEditingVC
                controller.creating = true
            default:break
            }
        }
    }
    
}
