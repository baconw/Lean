//
//  CompletedTodoTVCTableViewController.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/17.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit

class CompletedTodoTVC: UITableViewController,TodoContentCellProtocol {
    
    var completedTodos:[Todo] = []
    var todoRepository = TodoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.removeExtraSeperators()
        tableView.tableFooterView!.addSubview(spinner)
        spinner.center = CGPointMake(CGRectGetWidth(tableView.tableFooterView!.frame)/2, 22)
        
        
        completedTodos = todoRepository.getCompletedTodos(0,limit:8)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "completeTodo:", name: Constants.COMPLETE_TODO_NOTIFICATION, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,name:Constants.COMPLETE_TODO_NOTIFICATION,object:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //println("number of completed todos = \(completedTodos.count)")
        return completedTodos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CompletedTodoCell", forIndexPath: indexPath) as! CompletedTodoCell

        // Configure the cell...
        var todo = completedTodos[indexPath.row]
        cell.config(todo)
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66.0
    }
    
    func updateTodoState(cell: TodoContentCell, completed: Bool) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        let todo = completedTodos[indexPath.row]
        if(!completed){
            tableView.beginUpdates()
            todoRepository.recoverTodo(todo)
            completedTodos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
            tableView.endUpdates()
        }
        println("updateTodoState")
    }
    
    func completeTodo(notification:NSNotification) {
        if let userInfo = notification.userInfo {
            completedTodos.insert(userInfo["Todo"] as! Todo, atIndex: 0)
            tableView.reloadData()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    lazy var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        return view
    }()
    
    func loadMoreCompletedTodos(){
        let start = completedTodos.count
        let todos = todoRepository.getCompletedTodos(start, limit: 2)
        for todo in todos {
            completedTodos.append(todo)
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let end = scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame)
        if !completedTodos.isEmpty && scrollView.contentOffset.y > 0 && end > scrollView.contentSize.height {
            spinner.startAnimating()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let end = scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame)
        if end > scrollView.contentSize.height {
            loadMoreCompletedTodos()
            spinner.stopAnimating()
            tableView.reloadData()
        }
    }

}
