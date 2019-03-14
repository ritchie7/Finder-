//
//  VerticalCenterTextFieldCell.swift
//  mousePlus
//
//  Created by ritchie on 2018/11/16.
//  Copyright © 2018 ritchie. All rights reserved.
//

import Cocoa

class CenterTextFieldCell: NSTextFieldCell {

    func adjustedToVerticallyCenter(rect : NSRect) -> CGRect {
        
        let offset = floor((NSHeight(rect) / 2 - (self.font!.ascender + self.font!.descender)))
        
        // 向右移动一点
        return NSInsetRect(rect, 15.0, offset + 3.5)
        
    }
    
    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        
        super.edit(withFrame: self.adjustedToVerticallyCenter(rect: rect), in: controlView, editor: textObj, delegate: delegate, event: event)
        
    }
    
    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        
        super.select(withFrame: self.adjustedToVerticallyCenter(rect: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
        
    }
    
    
    
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        
        super.drawInterior(withFrame: self.adjustedToVerticallyCenter(rect: cellFrame), in: controlView)
    }
}
