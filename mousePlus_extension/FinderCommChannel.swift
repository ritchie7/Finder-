//
//  FinderCommChannel.swift
//  mousePlus_extension
//
//  Created by ritchie on 2018/10/26.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa

class FinderCommChannel: NSObject {

    func setup() {
//        var noti =
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(preferencesObserving), name: Notification.Name(rawValue: "PreferencesObservingNotification"), object: nil)
    }
    
    func postNotification(name : String, info : Any) {
        
    }
    
    @objc func preferencesObserving(noti : Notification) {
        
    }
    
}
