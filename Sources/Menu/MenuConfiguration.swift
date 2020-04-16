//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 13.04.20.
//

import Cocoa

public enum Alignment {
    case left
    case right
}

public enum Padding {
    public struct Horizontal {
        let left: CGFloat
        let right: CGFloat

        public init(left: CGFloat, right: CGFloat) {
            self.left = left
            self.right = right
        }
    }

    public struct Vertical {
        let top: CGFloat
        let bottom: CGFloat

        public init(top: CGFloat, bottom: CGFloat) {
            self.top = top
            self.bottom = bottom
        }
    }
}

extension Padding.Horizontal {
    public static var zero: Padding.Horizontal {
        return Padding.Horizontal(left: 0.0, right: 0.0)
    }
}

extension Padding.Vertical {
    public static var zero: Padding.Vertical {
        return Padding.Vertical(top: 0.0, bottom: 0.0)
    }
}

public protocol Configuration {
    var titleBottomSpace: CGFloat                           { get }
    var titleFont: NSFont?                                  { get }
    var titleColor: NSColor                                 { get }
    var backgroundColor: NSColor                            { get }
    var cornerRadius: CGFloat                               { get }
    var hasShadow: Bool                                     { get }
    var appearsBelowSender: Bool                            { get }
    var contentEdgeInsets: NSEdgeInsets                     { get }
    var maximumContentHeight: CGFloat?                      { get }
    var separatorColor: NSColor                             { get }
    var separatorThickness: CGFloat                         { get }
    var separatorHorizontalPadding: Padding.Horizontal      { get }
    var separatorVerticlaPadding: Padding.Vertical          { get }
    var rememberSelection: Bool                             { get }
    var textAlignment: Alignment                            { get }
    var iconAlignment: Alignment                            { get }
    var menuItemFont: NSFont?                               { get }
    var menuItemHeight: CGFloat                             { get }
    var menuItemHoverBackgroundColor: NSColor               { get }
    var menuItemTextColor: NSColor                          { get }
    var menuItemHoverTextColor: NSColor                     { get }
    var menuItemCheckmarkColor: NSColor                     { get }
    var menuItemHoverCheckmarkColor: NSColor                { get }
    var menuItemCheckmarkHeight: CGFloat                    { get }
    var menuItemCheckmarkThikness: CGFloat                  { get }
    var menuItemImageHeight: CGFloat?                       { get }
    var menuItemImageTintColor: NSColor?                    { get }
    var menuItemHoverImageTintColor: NSColor?               { get }
}

open class MenuConfiguration: Configuration {
    public init() {}

    open var titleBottomSpace: CGFloat {
        return .grid1
    }

    open var titleFont: NSFont? {
        return NSFont.systemFont(ofSize: 18, weight: .light)
    }

    open var titleColor: NSColor {
        return NSColor.white
    }

    open var backgroundColor: NSColor {
        return NSColor.init(calibratedRed: 84/255, green: 181/255, blue: 146/255, alpha: 1.0)
    }

    open var cornerRadius: CGFloat {
        return 5.0
    }

    open var hasShadow: Bool {
        return true
    }

    open var appearsBelowSender: Bool {
        return true
    }

    open var contentEdgeInsets: NSEdgeInsets {
        return NSEdgeInsets(top: .grid2, left: .grid2, bottom: .grid2, right: .grid2)
    }

    open var maximumContentHeight: CGFloat? {
        return nil
    }

    open var separatorColor: NSColor {
        return NSColor.init(calibratedRed: 76/255, green: 161/255, blue: 132/255, alpha: 1.0)
    }

    open var separatorThickness: CGFloat {
        return 1
    }

    open var separatorHorizontalPadding: Padding.Horizontal {
        return .init(left: .grid2, right: .grid2)
    }

    open var separatorVerticlaPadding: Padding.Vertical {
        return .init(top: .gridHalf, bottom: .gridHalf)
    }

    open var rememberSelection: Bool {
        return true
    }

    open var textAlignment: Alignment {
        return .left
    }

    open var iconAlignment: Alignment {
        return .left
    }
    
    open var menuItemFont: NSFont? {
        return NSFont.systemFont(ofSize: 14, weight: .light)
    }

    open var menuItemHeight: CGFloat {
        return .grid5
    }

    open var menuItemHoverBackgroundColor: NSColor {
        return NSColor.init(calibratedRed: 76/255, green: 161/255, blue: 132/255, alpha: 1.0)
    }

    open var menuItemHoverTextColor: NSColor {
        return .white
    }

    open var menuItemTextColor: NSColor {
        return .white
    }

    open var menuItemCheckmarkColor: NSColor {
        return .white
    }

    open var menuItemHoverCheckmarkColor: NSColor {
        return .white
    }

    open var menuItemCheckmarkHeight: CGFloat {
        return .grid4
    }

    open var menuItemCheckmarkThikness: CGFloat {
        return 1.0
    }

    open var menuItemImageHeight: CGFloat? {
        return .grid3
    }

    open var menuItemImageTintColor: NSColor? {
        return .white
    }

    open var menuItemHoverImageTintColor: NSColor? {
        return .white
    }
}
