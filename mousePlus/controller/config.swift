//
//  config.swift
//  mousePlus
//
//  Created by ritchie on 2019/3/7.
//  Copyright © 2019 ritchie. All rights reserved.
//

import Cocoa

func configData() {
    
    if (kFIRST_INSTALL()) {
        
        UserDefaults.standard.setValue("未命名文件", forKey: GENERAL_FILE_NAME)
        UserDefaults.standard.set(1, forKey: GENERAL_COPYPATH_SWITCH)
        UserDefaults.standard.set(1, forKey: GENERAL_OPEN_TERMINAL_SWITCH)
        UserDefaults.standard.set(1, forKey: GENERAL_FILE_CREAT_OPEN)
        UserDefaults.standard.set(1, forKey: GENERAL_SUBMENU_SWITCH)
        
        // 预置模板
        let names = ["txt", "keynot", "pages", "numbers", "word", "excel", "ppt", "md"]
        let sufixs = ["txt", "key", "pages", "numbers", "docx", "xlsx", "pptx", "md"]
        let images = ["txt", "keynot", "pages", "numbers", "word", "excel", "ppt", "md"]
        var tempalteData = Array<NSDictionary>()

        for idx in 0...(names.count - 1) {
            
            tempalteData.append(["name":names[idx], "check":1, "image":images[idx], "suffix":sufixs[idx]])
            
        }
        
        UserDefaults.standard.set(tempalteData, forKey: CONFIG_TEMPLATE_DATA)
    }
    
    // 放在外面防止被删除
    // 自定义模板
//    let tmps = Array<NSDictionary>()
//    UserDefaults.standard.set(tmps, forKey: kCUSTOM_TEMPLATE_DATA)
    
    let manager = FileManager.default
    
    let exist = manager.fileExists(atPath: kCUSTOM_TEMPLATE_FOLDER)
    
    if !exist {
        
        try! manager.createDirectory(atPath: kCUSTOM_TEMPLATE_FOLDER, withIntermediateDirectories: true, attributes: nil)
        
    } else {
        
        //            NSArray.init(contentsOf: NSURL.fileURL(withPath: kCUSTOM_TEMPLATE_FOLDER))
        //            print(files)
    }
}



