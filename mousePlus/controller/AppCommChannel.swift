//
//  AppCommChannel.swift
//  mousePlus
//
//  Created by ritchie on 2018/10/26.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa

class AppCommChannel: NSObject {

//    func setup() {
//
//        DistributedNotificationCenter.default().addObserver(self, selector: #selector(mousePlusActionObserving), name: NSNotification.Name(rawValue: "MousePlusActionObservingNotification"), object: nil);
//
//    }
    
    func postNotification(name : String) {
         DistributedNotificationCenter.default().postNotificationName(NSNotification.Name(rawValue: kMousePlusExtensionObservingNotification), object: "", userInfo: nil, deliverImmediately: true)
    }
    
//    @objc func mousePlusActionObserving(noti : Notification)  {
//        
//    }
}


