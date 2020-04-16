//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 16.04.20.
//

import Cocoa

class ScrollView: NSScrollView {
    var isScrollingEnabled = true
    override func scrollWheel(with event: NSEvent) {
        if isScrollingEnabled {
            super.scrollWheel(with: event)
        }
    }
}
