//
//  PerferenceViewController.swift
//  mousePlus
//
//  Created by ritchie on 2018/10/26.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa

class PreferenceViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)
        
        guard let itemView = tabViewItem?.view,
            let window = view.window
            else {return}
        
        
        let oldFrame = window.frame
        
        let newViewSize = itemView.fittingSize
        
        var newFrame = window.frameRect(forContentRect: NSMakeRect(oldFrame.origin.x, oldFrame.origin.y, newViewSize.width, newViewSize.height))
        
        let newY = oldFrame.origin.y - ( newFrame.size.height - oldFrame.size.height)
        newFrame.origin = NSMakePoint(oldFrame.origin.x, newY)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            window.animator().setFrame(newFrame, display: window.isVisible)
        }, completionHandler: nil)
        
    }
}
