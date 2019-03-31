//
//  main.swift
//  Helper
//
//  Created by ritchie on 2019/3/29.
//  Copyright © 2019 ritchie. All rights reserved.
//

import Foundation

class ServiceDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        //绑定服务接口
        newConnection.exportedInterface = NSXPCInterface(with: HelperProtocol.self)
        
        let helper = Helper()
        
        //创建服务实现类并且绑定到connection
        newConnection.exportedObject = helper
        
//        newConnection.remoteObjectInterface = NSXPCInterface(with: CallbackProtocol.self)
//        
//        helper.connection = newConnection
        
        //准备等待接口调用
        newConnection.resume()
        return true
    }
}
// 创建服务代理
let delegate = ServiceDelegate()
// 创建listener 准备监听服务请求
let listener = NSXPCListener.service()
//设置服务代理
listener.delegate = delegate;
// 启动服务监听.
listener.resume()
