//
//  config.swift
//  mousePlus
//
//  Created by ritchie on 2019/3/7.
//  Copyright © 2019 ritchie. All rights reserved.
//

import Cocoa


public let MouseUserDefult = UserDefaults(suiteName: USERDEFULT_NAME)!

   
func configData() {
    
    if (kFIRST_INSTALL()) {
        
        MouseUserDefult.setValue("未命名文件", forKey: GENERAL_FILE_NAME)
        MouseUserDefult.set(1, forKey: GENERAL_COPYPATH_SWITCH)
        MouseUserDefult.set(1, forKey: GENERAL_FILE_CREAT_OPEN)
        MouseUserDefult.set(0, forKey: GENERAL_SUBMENU_SWITCH)
        
        // 预置模板
        let names = ["txt", "keynot", "pages", "numbers", "word", "excel", "ppt", "md"]
        let sufixs = ["txt", "key", "pages", "numbers", "docx", "xlsx", "pptx", "md"]
        
        var tempalteData = Array<NSDictionary>()
        
        for idx in 0...(names.count - 1) {
            
            let path = Bundle.main.path(forResource: names[idx], ofType: sufixs[idx])!
            
            tempalteData.append(["name":names[idx], "check":1, "url":path])
            
        }
        
        let tmps = Array<NSDictionary>()
        MouseUserDefult.set(tmps, forKey: kCUSTOM_TEMPLATE_DATA)
        
        MouseUserDefult.set(tempalteData, forKey: CONFIG_TEMPLATE_DATA)
    }
    
    // 放在外面防止被删除
    // 自定义模板
    
    let manager = FileManager.default
    
    let exist = manager.fileExists(atPath: kCUSTOM_TEMPLATE_FOLDER)
    
    if !exist {
        
        try! manager.createDirectory(atPath: kCUSTOM_TEMPLATE_FOLDER, withIntermediateDirectories: true, attributes: nil)
        
    } else {
        
    }
}

func readCustomTemplateData() -> Array<NSDictionary> {
    
    var filesData = readsFiles(atPath: kCUSTOM_TEMPLATE_FOLDER)!
//        let filesData = FBXFileManager.readsFiles(atPath: kCUSTOM_TEMPLATE_FOLDER)!
    var tmpData = Array<String>()
    for item in filesData {
        let path = kCUSTOM_TEMPLATE_FOLDER + "/" + item
        tmpData.append(path)
    }
    filesData = tmpData
    
    let datas = MouseUserDefult.object(forKey: kCUSTOM_TEMPLATE_DATA) as! [NSDictionary]
    
    var configData = datas
    //        // 先取出 datas 里 files 没有的数据（配置文件里多余的辣鸡数据）
    for configItem in datas {
        
        let configURL = configItem["url"] as! String
        var have = false
        
        for fileItem in filesData {
            
            let fileURL = fileItem
            
            if fileURL == configURL {
                have = true
                break
            }
        }
        
        if !have { configData.removeAll(where: {$0 === configItem}) }
    }
    
    
    // 在 datas 里加入 files 有 datas 没有的数据
    for fileItem in filesData {
        
        let fileURL = fileItem
        var have = false
        
        for configItem in datas {
            
            let configURL = configItem["url"] as! String
            
            if configURL == fileURL {
                have = true
                break
            }
        }
        let fileURLPath = NSURL.init(fileURLWithPath: fileURL)
        let name = fileURLPath.deletingPathExtension!.lastPathComponent.removingPercentEncoding!
        if !have { configData.append(["url":fileURL, "name": name]) }
    }
    return configData
}

func readsFiles(atPath : String) -> [String]? {
    
    let exist = FileManager.default.fileExists(atPath: atPath)
    if !exist {
        
        print("不存在该路径")
        return nil
    }
    //        let files = try?FileManager.default.contentsOfDirectory(atPath: atPath)
//    let files = try? FileManager.default.contentsOfDirectory(at: URL.init(string: atPath)!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
    let files = try? FileManager.default.contentsOfDirectory(atPath: atPath)
    return files
    
}
