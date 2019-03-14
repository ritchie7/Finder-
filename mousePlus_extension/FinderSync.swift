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
    
    override init() {
        super.init()
        
        
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
        
    }
    

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        // Produce a menu for the extension.
        
//        let datas = 
        
        let menu = NSMenu(title: "test")
        menu.addItem(withTitle: "test2", action: #selector(sampleAction(_:)), keyEquivalent: "")
        
//        let menu1 = NSMenu(title: "拷贝路径")
        menu.addItem(withTitle: "拷贝路径", action: #selector(copyPath(_:)), keyEquivalent: "")
        
        return menu
    }
    
    
    @objc func copyPath(_ sender: AnyObject?) {
        currentURL = (FIFinderSyncController.default().targetedURL()?.path)!
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(currentURL, forType: NSPasteboard.PasteboardType.string)
    }
    
    @objc func sampleAction(_ sender: AnyObject?) {

        
        DispatchQueue.main.async {
            
            let panel = NSSavePanel()
            
            panel.title = "新建文档"
            panel.allowedFileTypes = ["txt"]
            panel.nameFieldStringValue = "新建文档"
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
