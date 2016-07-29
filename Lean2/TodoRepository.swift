//
//  TodoRepository.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/13.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit
import CoreData

class TodoRepository {

    var managedObjectContext: NSManagedObjectContext
    
    init() {
        self.managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    }
    
    func initData() {
        
        
        if(getAllTodolists().count > 0){
            return
        }

        deleteAllData()
        
        let todolist1 = NSEntityDescription.insertNewObjectForEntityForName("Todolist", inManagedObjectContext: managedObjectContext) as! Todolist
        todolist1.content = "生活"
        let todolist2 = NSEntityDescription.insertNewObjectForEntityForName("Todolist", inManagedObjectContext: managedObjectContext) as! Todolist
        todolist2.content = "工作"
        
        let todo1 = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: managedObjectContext) as! Todo
        todo1.dueDate = DateUtils.today()
        todo1.content = "吃饭"
        todo1.todolist = todolist1
        
        let todo2 = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: managedObjectContext) as! Todo
        todo2.dueDate = DateUtils.tomorrow()
        todo2.content = "睡觉"
        todo2.todolist = todolist1

        
        let todo3 = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: managedObjectContext) as! Todo
        todo3.dueDate = DateUtils.nextWeek()
        todo3.content = "打豆豆"
        todo3.todolist = todolist2

        managedObjectContext.save(nil)
        
    }
    
    func getTodoOfTodolist(todolist:Todolist) -> [Todo]{
        let fetchRequest = NSFetchRequest(entityName: "Todo")
        
        let predicator = NSPredicate(format: "completed = NO and todolist = %@", todolist)
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicator
        
        return self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [Todo]
    }
    
    func getAllTodos() -> [Todo] {
        let fetchRequest = NSFetchRequest(entityName: "Todo")
        return managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [Todo]
    }
    
    func getAllUncompletedTodos() -> [Todo] {
        let fetchRequest = NSFetchRequest(entityName: "Todo")
        let predicator = NSPredicate(format: "completed = NO")
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicator
        
        return managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [Todo]
    }
    
    func getCompletedTodos(start:Int, limit:Int) -> [Todo] {
        let fetchRequest = NSFetchRequest(entityName: "Todo")
        
        let predicator = NSPredicate(format: "completed = YES")
        let sortDescriptor = NSSortDescriptor(key: "completedTime", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicator
        
        fetchRequest.fetchOffset = start
        fetchRequest.fetchLimit = limit
        
        return self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [Todo]
    }
    
    func getAllTodolists() -> [Todolist] {
        let fetchRequest = NSFetchRequest(entityName: "Todolist")
        return managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [Todolist]
    }
    
    func deleteAllData(){
        for todolist in getAllTodolists(){
            managedObjectContext.deleteObject(todolist)
        }
        for todo in getAllTodos() {
            managedObjectContext.deleteObject(todo)
        }
        saveContext()
    }
    
    func moveTodo(todo:Todo, destination: Todolist) {
        todo.todolist = destination
        saveContext()
    }
    
    func completeTodo(todo:Todo) {
        todo.completed = true
        todo.completedTime = NSDate()
        saveContext()
    }
    
    func recoverTodo(todo:Todo) {
        todo.completed = false
        saveContext()
    }
    
    func createEmptyTodo() -> Todo {
        let todo = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: managedObjectContext) as! Todo
        todo.dueDate = DateUtils.today()
        todo.content = ""
        todo.todolist = getAllTodolists()[0]
        return todo
    }

    
    func deleteTodo(todo: Todo) {
        managedObjectContext.deleteObject(todo)
    }
    
    func saveContext() {
        managedObjectContext.save(nil)
    }
}
