//
//  PerferenceWindowController.swift
//  mousePlus
//
//  Created by ritchie on 2018/10/26.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa

class PreferenceWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.styleMask.remove(.resizable)
//        self.window!.standardWindowButton(.zoomButton)!.isHidden = true
//        self.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true

    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        
        exit(0)
        
    }
}
