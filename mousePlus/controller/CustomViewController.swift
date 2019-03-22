//
//  CustomViewController.swift
//  mousePlus
//
//  Created by ritchie on 2018/11/16.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa

class CustomViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var segment: NSSegmentedControl!
    
    var datas: Array = [NSDictionary]() // 持久化数据
    var filesData: Array = [URL]() // 文件数据
//    var selectRow: NSInteger = -1
    
    let tableCellViewDataType = "CustomTableCellViewDataType"
    
    var selectRow: NSInteger = -1 {
        didSet {
            if (selectRow < 0) {
                self.segment.setEnabled(false, forSegment: 1)
            } else {
                self.segment.setEnabled(true, forSegment: 1)
            }
        }
    }
    
    
    var manager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.preferredContentSize = view.frame.size
        
//        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: USERDEFULT_NAME)
        
        self.tableviewConfig()
        self.updateData()
        
    }
    
    func tableviewConfig() {
        
        self.segment.setEnabled(false, forSegment: 1)
        //背景颜色交替
        self.tableView.usesAlternatingRowBackgroundColors = true
        //表格行选中样式
        self.tableView.selectionHighlightStyle = .regular
        
        self.tableView.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: self.tableCellViewDataType)])
    }
    
    func updateData() {


        self.datas = readCustomTemplateData()
        
        
        self.tableView.reloadData()
        
        
    }
    
    // MARK: - 拖动排序
    // 第一步：设置响应，建立属性面板
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        
        let data = try? NSKeyedArchiver.archivedData(withRootObject: rowIndexes, requiringSecureCoding: true)
        
        pboard.declareTypes([NSPasteboard.PasteboardType(rawValue: self.tableCellViewDataType)], owner: self)
        
        pboard.setData(data, forType: NSPasteboard.PasteboardType(rawValue: self.tableCellViewDataType))
        
        return true
    }
    
    // 第二步：响应处理，替换数据
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
            self.tableView .reloadData()
            
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
    func addRowEvent(_ sender: Any) {
        
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = false
        
        panel.directoryURL = NSURL.fileURL(withPath: kPATH_DOCUMENT)
        
        panel.begin { (result) in

            if result != NSApplication.ModalResponse.OK {return}
            
            let url = panel.urls.first
            
            let lastPath = url?.lastPathComponent
            
            let toPath = URL.init(fileURLWithPath: kCUSTOM_TEMPLATE_FOLDER).appendingPathComponent(lastPath!)
            
            
            let success = self.copyFile(sourcePath: url!, toPath: toPath)
            
            if success {
                let data = ["url":toPath.absoluteString]
                
                self.datas.append(data as NSDictionary)
                
                self.tableView.reloadData()
            } else {
                kALERT("添加失败")
            }

        }

    }

    
    func removeRowEvent(_ sender: Any) {
        
        let alert = NSAlert()
        alert.addButton(withTitle: "确定")
        alert.addButton(withTitle: "取消")
        alert.messageText = "移除模板"
        alert.informativeText = "是否确认移除模板"
        alert.alertStyle = NSAlert.Style.warning
        alert.beginSheetModal(for: self.view.window!) { (result) in
            
            if result == NSApplication.ModalResponse.alertFirstButtonReturn { // 确认删除
                
                var url = self.datas[self.selectRow]["url"] as! String
                url = url.removingPercentEncoding!
                let success = try? FileManager.default.removeItem(at: URL.init(fileURLWithPath: url))
                
                if (success != nil) {
                    
                    self.datas.remove(at: self.selectRow)
                    self.tableView.reloadData()
                    
                }
            }
        }
        
    }

    @IBAction func segmentAction(_ sender: NSSegmentedControl) {
        
        if sender.indexOfSelectedItem == 1 {
            
            self.removeRowEvent(sender)
            
        } else {
            
            self.addRowEvent(sender)
        }
    }
    
    @IBAction func checkAction(_ check: NSButton) {
        
        let rowView = check.superview as! NSTableRowView
        let row = self.tableView .row(for: rowView)
        
        let state = check.state
        print("state :\(state)")
        print("row :\(row)")
    }
    

    func controlTextDidEndEditing(_ obj: Notification) {
        let cell = self.tableView.selectedCell() as? NSTextFieldCell
        
        if (cell?.stringValue.length == 0)
        {
            kALERT("文件名不能为空")
            return
        }
        
        if (cell?.isKind(of: NSTextFieldCell.self))! {
            let row = self.tableView.selectedRow
            
            let value = cell?.stringValue
            let srcPtah = self.datas[row]["url"] as! String
            
            let srcURL = URL.init(fileURLWithPath: srcPtah)
            
            let name = srcURL.deletingPathExtension().lastPathComponent.removingPercentEncoding
            let dstPath = srcURL.path.removingPercentEncoding!.replace(of: name!, with: value!)
            
            let srcStr = srcURL.path.removingPercentEncoding
            let dstStr = dstPath
            
            do {
                try FileManager.default.moveItem(atPath: srcStr!, toPath: dstStr)
            } catch {
                kALERT(error.localizedDescription)
            }
            
            self.updateData()
        }
    }
    
    
    func copyFile(sourcePath: URL, toPath: URL) -> Bool {
        
        return ((try? FileManager.default.copyItem(at: sourcePath, to: toPath)) != nil)
        
    }
    
    func changeTemplateData() {
        
        MouseUserDefult.set(self.datas, forKey: kCUSTOM_TEMPLATE_DATA)
    }
}


extension CustomViewController : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        changeTemplateData()
        return self.datas.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        let data = self.datas[row]
        let path = data["url"] as! String
        let url = URL.init(fileURLWithPath: path)
        
        // 表格列标识
        let key = tableColumn?.identifier
        
        if (key?.rawValue == "image") {
            
            let image = NSWorkspace.shared.icon(forFileType: url.pathExtension)
            return image
            
        }
        let str = url.deletingPathExtension().lastPathComponent.removingPercentEncoding

        return str
    }
    
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        let data = self.datas[row]
        //表格列的标识
        let key = tableColumn?.identifier
        
        let editData = NSMutableDictionary.init(dictionary: data)
        
        editData[key!] = object
        
        self.datas[row] = editData
    }
}

extension CustomViewController : NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        selectRow = self.tableView.selectedRow
        
    }
}
