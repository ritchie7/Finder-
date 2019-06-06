//
//  AppDelegate.swift
//  mousePlus
//
//  Created by ritchie on 2018/10/26.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainWindow: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        mainWindow = NSApplication.shared.windows[0] 
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag
        {
            mainWindow.makeKeyAndOrderFront(nil)
            
        }
        return true
    }
    
    @IBAction func preerencesEvent(_ sender: Any) {
    }
    
}

