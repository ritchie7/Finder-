//
//  GeneralViewController.swift
//  mousePlus
//
//  Created by ritchie on 2018/10/26.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa

class GeneralViewController: NSViewController {
    
    
    @IBOutlet weak var openTerminal: NSButton!
    
    @IBOutlet weak var openFile: NSButton!
    
    @IBOutlet weak var copyPath: NSButton!
    
    @IBOutlet weak var submenu: NSButton!

    @IBOutlet weak var fileNameTextField: NSTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = view.frame.size
        
        configData()
        
        // 文本框
        self.fileNameTextField.refusesFirstResponder = true // 放弃第一响应者
        
        let name: String = UserDefaults.standard.string(forKey: GENERAL_FILE_NAME)!
        self.fileNameTextField.stringValue = name
        
        // 拷贝路径
        let copyState: NSInteger = UserDefaults.standard.integer(forKey: GENERAL_COPYPATH_SWITCH)
        self.copyPath.state = NSControl.StateValue(rawValue: copyState)
        
        // 新建后打开
        let creatOpenState: NSInteger = UserDefaults.standard.integer(forKey: GENERAL_FILE_CREAT_OPEN)
        self.openFile.state = NSControl.StateValue(rawValue: creatOpenState)
        
        // 拷贝路径至终端
        let openTerminalState: NSInteger = UserDefaults.standard.integer(forKey: GENERAL_OPEN_TERMINAL_SWITCH)
        self.openTerminal.state = NSControl.StateValue(rawValue: openTerminalState)

        
    }
    
    // MARK: - Action
    @IBAction func copyPathSwitchAction(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: GENERAL_COPYPATH_SWITCH)
    }
    @IBAction func openTerminalSwitchAction(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: GENERAL_OPEN_TERMINAL_SWITCH)
    }
    @IBAction func openFileAfterCreatSwitchAction(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: GENERAL_FILE_CREAT_OPEN)
    }
    @IBAction func submenuSwitchAction(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: GENERAL_SUBMENU_SWITCH)
    }
    @IBAction func systemConfgAction(_ sender: Any) {
        
        let extensionURL = """
                            tell application \"System Preferences\"
                            launch
                            activate
                            reveal pane \"com.apple.preferences.extensions\"
                            end tell
                           """
        
        let event = NSAppleScript(source: extensionURL)
        event?.executeAndReturnError(nil)
        
        // 成为焦点窗口
        NSWorkspace.shared.launchApplication(withBundleIdentifier: "com.apple.systempreferences", options: [], additionalEventParamDescriptor: nil, launchIdentifier: nil)
        
    }
}

extension GeneralViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        
        UserDefaults.standard.setValue(self.fileNameTextField.stringValue, forKey: GENERAL_FILE_NAME)
    }
}
