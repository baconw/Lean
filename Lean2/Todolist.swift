//
//  Todolist.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/15.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import Foundation
import CoreData

class Todolist: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var todos: NSSet

}
