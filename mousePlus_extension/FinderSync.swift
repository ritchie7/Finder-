//
//  FinderSync.swift
//  mousePlus_extension
//
//  Created by ritchie on 2018/10/26.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {

    var myFolderURL = URL(fileURLWithPath: "/")
    var currentURL :String = ""
    
    var fileName: String = ""
    var copyState: NSInteger = 0
    var creatOpenState: NSInteger = 0
    var submenuState: NSInteger = 0
    var customData: Array<NSDictionary>!
    var templateData: Array<NSDictionary>!
    
    override init() {
        super.init()
        
        
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
//        MouseUserDefult.setValue("未命名文件", forKey: GENERAL_FILE_NAME)
        self.fileName = MouseUserDefult.string(forKey: GENERAL_FILE_NAME) ?? "新建文件"

////        // 拷贝路径
        self.copyState = MouseUserDefult.integer(forKey: GENERAL_COPYPATH_SWITCH)
//
//        // 新建后打开
        self.creatOpenState = MouseUserDefult.integer(forKey: GENERAL_FILE_CREAT_OPEN)
//
//        // 子菜单方式
        self.submenuState = MouseUserDefult.integer(forKey: GENERAL_SUBMENU_SWITCH)
        
    }
    

    override func menu(for menuKind: FIMenuKind) -> NSMenu {

        if self.submenuState != 0 { // 这个值好像没取到...
            let menu = NSMenu(title: "mouse+")
            let subMenu1 = NSMenu(title: "mouse+2")
            let item = NSMenuItem(title: "mouse+", action: nil, keyEquivalent: "")
            menu.addItem(item)
            subMenu1.addItem(withTitle: "拷贝路径", action:#selector(copyPath(_:)) , keyEquivalent: "")
            menu.setSubmenu(subMenu1, for: item)
            return menu
        }
        let menu = NSMenu(title: "mouse+")
        return menu
    }
    
    
    @objc func copyPath(_ sender: AnyObject?) {
        currentURL = (FIFinderSyncController.default().targetedURL()?.path)!
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(currentURL, forType: NSPasteboard.PasteboardType.string)
    }
    
    @objc func sampleAction(_ sender: AnyObject?) {

//        self.fileName = MouseUserDefult.value(forKey: GENERAL_FILE_NAME) as! String

        DispatchQueue.main.async {
            
            let panel = NSSavePanel()
            
            panel.title = "新建文档"
            panel.allowedFileTypes = ["txt"]
            panel.nameFieldStringValue = self.fileName
            panel.isExtensionHidden = false
            
            let path = Bundle.main.path(forResource: "Text", ofType: "txt")

            panel.level = NSWindow.Level.floating
            NSApp.activate(ignoringOtherApps: true)
            panel.begin(completionHandler: { (result) in
                if result == NSApplication.ModalResponse.OK {
//                    do {
//                        try FileManager.default.copyItem(at: NSURL.fileURL(withPath: path!), to: panel.url!)
//                    } catch let error as NSError {
//                        print(error.localizedDescription)
//                    }
                    try! FileManager.default.copyItem(at: NSURL.fileURL(withPath: path!), to: panel.url!)
                } else {

                }
                
            })
        }
    }
}

//extension FinderSync: NSOpenSavePanelDelegate {
//    func panel(_ sender: Any, willExpand expanding: Bool) {
//
//    }
//}
