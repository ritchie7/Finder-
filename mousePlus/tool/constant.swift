//
//  constant.swift
//  mousePlus
//
//  Created by ritchie on 2018/12/28.
//  Copyright © 2018 ritchie. All rights reserved.
//


import Cocoa

// MARK: - PATH
let kPATH_DOCUMENT = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
let kPATH_LIBRARY = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
let kPATH_CACHE = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
let kPATH_PREFER = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.preferencePanesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]



// MARK: - COLOR
func kCOLOR_RGBA(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat, _ alpha:CGFloat) -> NSColor {
    return NSColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}
func kCOLOR_RGB(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat) -> NSColor {
    return kCOLOR_RGBA(red, green, blue, 1)
}

func kCOLOR_HEX_A(_ hex:Int, _ alpha:CGFloat) -> NSColor {
    return NSColor.init(red: CGFloat((hex & 0xFF0000) >> 16)/255.0, green: CGFloat((hex & 0xFF00) >> 8)/255.0, blue: CGFloat(hex & 0xFF)/255.0, alpha: alpha)
}
func kCOLOR_HEX_A(_ hex:Int) -> NSColor {
    return kCOLOR_HEX_A(hex, 1)
}


// MARK: - ALERT
func kALERT(_ message:String) {
    let alert = NSAlert()
    alert.messageText = message
    alert.runModal()
}


func kFIRST_INSTALL() -> Bool {
    if (UserDefaults.standard.bool(forKey: CONFIG_INSTALL_FIRST)) == false { // 第一次加载
        UserDefaults.standard.set(true, forKey: CONFIG_INSTALL_FIRST)
        return true
    }
    return false
}
