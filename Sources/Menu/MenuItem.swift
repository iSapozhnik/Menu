//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 10.04.20.
//

import Cocoa

public struct MenuItem: CustomDebugStringConvertible {
    let action: (() -> Void)?
    let title: String
    let image: NSImage?
    let isSelectable: Bool
    var isSeparator = false
    public let id: UUID

    public init(_ title: String, image: NSImage? = nil, isSelectable: Bool = true, action: (() -> Void)?) {
        self.action = action
        self.title = title
        self.image = image
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
