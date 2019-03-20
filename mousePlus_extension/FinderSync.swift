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
    var customData = [NSDictionary]()
    var templateData = [NSDictionary]()
    
    var menuArray: Array<Array<MenuModel>>!
    
    var customMenu: NSMenu?
    var preinstallMenu: NSMenu?
    
    override init() {
        super.init()
        
        
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
        
        self.fileName = MouseUserDefult.string(forKey: GENERAL_FILE_NAME) ?? "新建文件"

        // 拷贝路径
        self.copyState = MouseUserDefult.integer(forKey: GENERAL_COPYPATH_SWITCH)
//
        // 新建后打开
        self.creatOpenState = MouseUserDefult.integer(forKey: GENERAL_FILE_CREAT_OPEN)
//
        // 子菜单方式
        self.submenuState = MouseUserDefult.integer(forKey: GENERAL_SUBMENU_SWITCH)

//        self.customData = readCustomTemplateData()
        self.customData = MouseUserDefult.value(forKey: kCUSTOM_TEMPLATE_DATA) as! [NSDictionary]
//
        self.templateData = MouseUserDefult.value(forKey: CONFIG_TEMPLATE_DATA) as! [NSMutableDictionary]

    }
    

    override func menu(for menuKind: FIMenuKind) -> NSMenu {

        if self.submenuState == 1 { // 子菜单方式显示
            let menu = NSMenu(title: "mouse+")
            let subMenu1 = self.subMenu()
            let item = NSMenuItem(title: "mouse+", action: nil, keyEquivalent: "")
            menu.addItem(item)
            menu.setSubmenu(subMenu1, for: item)
            return menu
        }
        
        return subMenu()
    }
    
    
    @objc func copyPath(_ sender: AnyObject?) {
        currentURL = (FIFinderSyncController.default().targetedURL()?.path)!
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(currentURL, forType: NSPasteboard.PasteboardType.string)
    }
    

    
    @objc func creatPreinstallFile(_ sender: NSMenuItem?) {
        let title = sender?.title
        let url = getURL(title: title!, data: self.templateData)
        self.creatFile(url: url)
    }
//
    @objc func creatCustomFile(_ sender: AnyObject?) {
        let title = sender?.title
        let url = getURL(title: title!, data: self.customData)
        self.creatFile(url: url)
    }
    
    @objc func creatFile(url: URL)  {
        
        DispatchQueue.main.async {
            
            let panel = NSSavePanel()
            
            panel.title = "新建文档"
            
            
            panel.nameFieldStringValue = self.fileName
            panel.isExtensionHidden = false
            panel.canCreateDirectories = true
            panel.directoryURL = FIFinderSyncController.default().targetedURL()
            
            panel.level = NSWindow.Level.floating
            NSApp.activate(ignoringOtherApps: true)
            panel.begin(completionHandler: { (result) in
                if result == NSApplication.ModalResponse.OK {
                    
//                    let directoryURL =
//                    let succeed = try? FileManager.default.copyItem(at: url, to: panel.url!)
                    
//                    let succeed = try? "hhhhhh".write(to: panel.url!, atomically: true, encoding: String.Encoding.utf8)
//                    let data = NSData.init(contentsOfFile: url.path)
                    do {
                        let succeed = try FileManager.default.copyItem(at: url, to: panel.url!)

                    } catch {
                        let e = error
                        kALERT(error.localizedDescription)

                    }
//                    if (succeed == nil) {
//                        kALERT("创建失败")
//                    }
                } else {
                    
                }
                
            })
        }
    }
    
    func getURL(title: String, data: Array<NSDictionary>) -> URL {
        
        for dict in data {
            let name = dict["name"] as! String
            if name == title {
                let path = dict["url"] as! String
                return URL.init(fileURLWithPath: path)
                
            }
        }
        return URL.init(string: "mouse+")!
    }
    
    func subMenu() -> NSMenu {
        let menu = NSMenu(title: "mouse+")
        
        if self.copyState == 1 {
            menu.addItem(withTitle: "拷贝路径", action:#selector(copyPath(_:)) , keyEquivalent: "")
        }
        
        if self.templateData.count == 0 && self.customData.count == 0 {return menu}
        
        let fileItem = NSMenuItem(title: "新建文件", action: nil, keyEquivalent: "")
        fileItem.representedObject = "哈哈哈哈哈哈"
        menu.addItem(fileItem)
        
        if (self.templateData.count != 0) {
            
            self.preinstallMenu = NSMenu.init(title: "预设文件")
            
            for data in self.templateData {
                
                
                let name = data["name"] as! String
                let menuItem = NSMenuItem.init(title: name, action: #selector(FinderSync.creatPreinstallFile(_:)), keyEquivalent: "")
                self.preinstallMenu!.addItem(menuItem)
                
            }
            
            menu.setSubmenu(self.preinstallMenu, for: fileItem)
        }
        
        
        if self.customData.count != 0 {
            
            let customMenuItem = NSMenuItem(title: "新建自定义文件", action: nil, keyEquivalent: "")
            menu.addItem(customMenuItem)
            
            self.customMenu =  NSMenu.init(title: "自定义文件Menu")
            
            for customData in self.customData {
                
                let name = customData["name"] as! String
                
                let menuItem = NSMenuItem.init(title: name, action: #selector(FinderSync.creatCustomFile(_:)), keyEquivalent: "")
                self.customMenu!.addItem(menuItem)
                
                menuItem.representedObject = 1
            }
            
            menu.setSubmenu(self.customMenu, for: customMenuItem)
        }
        
        return menu
    }
}

class MenuModel: NSObject {
    var url: String = ""
    var name: String = ""
    
    override init() {
        super.init()
    }
    
    init(url: String, name: String) {
        self.url = url
        self.name = name
    }
}

//extension FinderSync: NSOpenSavePanelDelegate {
//    func panel(_ sender: Any, willExpand expanding: Bool) {
//
//    }
//}
