//
//  TemplateViewController.swift
//  mousePlus
//
//  Created by ritchie on 2018/10/29.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa

class TemplateViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    var datas: Array = [NSMutableDictionary]()
    
    let tableCellViewDataType = "TemplateTableCellViewDataType"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.preferredContentSize = view.frame.size
        
        self.tableviewConfig()
        self.updateData()
        
        
    }
    
    
    func tableviewConfig() {
        
        //背景颜色交替
        self.tableView.usesAlternatingRowBackgroundColors = true
        //表格行选中样式
        self.tableView.selectionHighlightStyle = .regular
        
        self.tableView.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: self.tableCellViewDataType)])
    }
    
    func updateData() {
        
        self.datas = UserDefaults.standard.value(forKey: CONFIG_TEMPLATE_DATA) as! [NSDictionary] as! [NSMutableDictionary]
        

    }
    
    
    @IBAction func checkBoxEvent(_ check: NSButton) {
        
        let rowView = check.superview as! NSTableRowView
        let row = self.tableView.row(for: rowView)
        
        let state = check.state
        print("state :\(state)")
        print("row :\(row)")
    }
    
    // 第二步：设置响应，建立属性面板
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        
        let data = try? NSKeyedArchiver.archivedData(withRootObject: rowIndexes, requiringSecureCoding: true)
        
        pboard.declareTypes([NSPasteboard.PasteboardType(rawValue: self.tableCellViewDataType)], owner: self)
        
        pboard.setData(data, forType: NSPasteboard.PasteboardType(rawValue: self.tableCellViewDataType))
        
        return true
    }
    
    // 第三步：响应处理，替换数据
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        return NSDragOperation.every;
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        
        let pboard = info.draggingPasteboard
        
        let rowData = pboard.data(forType: NSPasteboard.PasteboardType(rawValue: self.tableCellViewDataType))
        
        let rowIdxs: NSIndexSet = NSKeyedUnarchiver.unarchiveObject(with: rowData!) as! NSIndexSet
//        let rowIdxs: NSIndexSet = try? NSKeyedUnarchiver.unarchivedObject(ofClass: IndexSet, from: rowData)
        let dragRow = rowIdxs.firstIndex
        
        if dragRow < row {
            
            self.datas.insert(self.datas[dragRow], at: row)
            self.datas.remove(at: dragRow)
            
            self.tableView.noteNumberOfRowsChanged()
            self.tableView.reloadData()
            
            return true
            
        }
        
        let zData = self.datas[dragRow]
        
        self.datas.remove(at: dragRow)
        self.datas.insert(zData, at: row)
        
        self.tableView.noteNumberOfRowsChanged()
        self.tableView.reloadData()
        
        return true
    }
    
    // MARK: - EVENT
    func changeTemplateData() {
        
        UserDefaults.standard.set(self.datas, forKey: CONFIG_TEMPLATE_DATA)
    }
    
    @IBAction func checkCellSelected(_ sender: NSButtonCell) {

        let row = self.tableView.selectedRow
        
        let data: NSMutableDictionary = self.datas[row].mutableCopy() as! NSMutableDictionary
        
        let rowView = self.tableView.selectedCell() as! NSButtonCell
        
        let state = rowView.state.rawValue
        
        data.setValue(state, forKey: "check")

        self.datas.remove(at: row)
        self.datas.insert(data, at: row)

        self.tableView.reloadData()
    }
}


extension TemplateViewController : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        changeTemplateData()
        
        return self.datas.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let data = self.datas[row]

        // 表格列标识
        let key = tableColumn?.identifier
        if (key!.rawValue == "image") {
            
            let image = data["image"] as! String
            let suffix = data["suffix"] as! String
            
            let path = Bundle.main.path(forResource: image , ofType: suffix)
            
            return NSImage.init(named: image)
        }
        
        let value = data[key!]
        return value
    }

    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        let data = self.datas[row]
        //表格列的标识
        let key = tableColumn?.identifier

        let editData = NSMutableDictionary.init(dictionary: data)

        editData[key!] = object

        self.datas[row] = editData
    }
    
    // 改文件名称
    func controlTextDidEndEditing(_ obj: Notification) {
        
        let cell = self.tableView.selectedCell() as? NSTextFieldCell
        
        if (cell?.isKind(of: NSTextFieldCell.self))! {
            
            
            let row = self.tableView.selectedRow
            let data: NSMutableDictionary = self.datas[row].mutableCopy() as! NSMutableDictionary
            
            data.setValue(cell?.stringValue, forKey: "name")
            
            self.datas.remove(at: row)
            self.datas.insert(data, at: row)
            
            
            changeTemplateData()
        }

    }
    
}

extension TemplateViewController: NSTableViewDelegate {

    
}


