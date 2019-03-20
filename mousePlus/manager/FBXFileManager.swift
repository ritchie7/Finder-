//
//  FBXFileManager.swift
//  mousePlus
//
//  Created by ritchie on 2018/12/28.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa

class FBXFileManager: NSObject {

    // 获取文件夹下所有文件路径
    func readsFiles(atPath : String) -> [URL]? {
        
        let exist = FileManager.default.fileExists(atPath: atPath)
        if !exist {
            
            print("不存在该路径")
            return nil
        }
//        let files = try?FileManager.default.contentsOfDirectory(atPath: atPath)
        let files = try? FileManager.default.contentsOfDirectory(at: URL.init(string: atPath)!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        return files
        
    }
    
    
}


