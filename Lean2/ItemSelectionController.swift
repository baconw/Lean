//
//  ItemSelectionController.swift
//  Lean2
//
//  Created by dongyi228 on 16/7/15.
//  Copyright (c) 2016年 dongyi228. All rights reserved.
//

import UIKit

class ItemSelectionController: UITableViewController {
    
    var itemsForSelection:[Todolist]!
    var selectedItem: Todolist!
    var indexPathOfSelectedItem: NSIndexPath!
    var delegate: ItemSelectionControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: Constants.ITEM_SELECTION_CELL_NIB, bundle: nil), forCellReuseIdentifier: Constants.ITEM_SELECTION_CELL_ID)
        self.tableView.separatorInset = UIEdgeInsetsMake(0,15,0,15)
        self.tableView.removeExtraSeperators()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsForSelection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ItemSelectionCell = tableView.dequeueReusableCellWithIdentifier(Constants.ITEM_SELECTION_CELL_ID, forIndexPath: indexPath) as! ItemSelectionCell
        
        if itemsForSelection[indexPath.row] === selectedItem {
            cell.config(itemsForSelection[indexPath.row].content, selected: true)
            indexPathOfSelectedItem = indexPath
        } else {
            cell.config(itemsForSelection[indexPath.row].content, selected: false)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ItemSelectionCell
        if itemsForSelection[indexPath.row] !== selectedItem {
            cell.config(true)
            let selectedCell = tableView.cellForRowAtIndexPath(indexPathOfSelectedItem) as! ItemSelectionCell
            selectedCell.config(false)
            self.delegate?.itemSelected(itemsForSelection[indexPath.row])
            
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}


protocol ItemSelectionControllerDelegate {
    func itemSelected(todolist: Todolist)
}