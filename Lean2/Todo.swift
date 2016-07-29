//
//  Todo.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/15.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import Foundation
import CoreData

class Todo: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var dueDate: NSDate
    @NSManaged var completed: NSNumber
    @NSManaged var completedTime: NSDate
    @NSManaged var order: NSNumber
    @NSManaged var todolist: Todolist

}
