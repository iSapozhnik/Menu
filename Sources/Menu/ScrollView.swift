//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 16.04.20.
//

import Cocoa

final class FlippedClipView: NSClipView {
    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        drawsBackground = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isFlipped: Bool {
        return true
    }
}

class ScrollView: NSScrollView {
    var isScrollingEnabled = true
    override func scrollWheel(with event: NSEvent) {
        if isScrollingEnabled {
            super.scrollWheel(with: event)
        }
    }
}
