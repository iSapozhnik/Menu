//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 10.04.20.
//

import Cocoa

public struct MenuItem {
    let action: () -> Void
    let title: String
    let image: NSImage?
    let isSelectable: Bool
    var isSeparator = false

    public init(_ title: String, image: NSImage? = nil, isSelectable: Bool = true, action: @escaping () -> Void = {}) {
        self.action = action
        self.title = title
        self.image = image
        self.isSelectable = isSelectable
    }

    public static func separator() -> MenuItem {
        var separatorItem = self.init("", isSelectable: false)
        separatorItem.isSeparator = true
        return separatorItem
    }
}
