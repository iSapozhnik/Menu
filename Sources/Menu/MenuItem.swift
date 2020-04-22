//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 10.04.20.
//

import Cocoa

public struct MenuItem: CustomDebugStringConvertible {
    public var isEnabled = true
    public let id: UUID

    let action: (() -> Void)?
    let title: String
    let image: NSImage?
    let isSelectable: Bool
    var customView: NSView?
    var isSeparator = false


    public init(_ customView: NSView) {
        self.init("", image: nil, customView: customView, isSelectable: false, action: nil)
    }

    public init(_ title: String, image: NSImage? = nil, customView: NSView? = nil, isSelectable: Bool = true, action: (() -> Void)?) {
        self.action = action
        self.title = title
        self.image = image
        self.customView = customView
        self.isSelectable = isSelectable
        id = UUID()
    }

    public static func separator() -> MenuItem {
        var separatorItem = self.init("", isSelectable: false, action: nil)
        separatorItem.isSeparator = true
        return separatorItem
    }

    public var debugDescription: String {
        return isSeparator ? "separator" : "title: \(title), id: \(id.uuidString)"
    }
}

extension MenuItem: Identifiable {}
