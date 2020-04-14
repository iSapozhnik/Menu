//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 10.04.20.
//

import Cocoa

final class Window: NSPanel {
    private var childContentView: NSView?
    private var backgroundView: RoundedRectangleView?
    private let configuration: Configuration

    private init(
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool,
        configuration: Configuration
    ) {
        self.configuration = configuration

        super.init(
            contentRect: contentRect,
            styleMask: style,
            backing: backingStoreType,
            defer: flag
        )

        isOpaque = false
        hasShadow = configuration.hasShadow
        backgroundColor = .clear
    }

    static func make(with configuration: Configuration) -> Window {
        return Window.init(
            contentRect: .zero,
            styleMask: .borderless,
            backing: .buffered,
            defer: true,
            configuration: configuration
        )
    }

    override func accessibilityIsIgnored() -> Bool {
        return true
    }

    override var contentView: NSView? {
        set {
            guard childContentView != newValue, let bounds = newValue?.bounds else { return }

            backgroundView = super.contentView as? RoundedRectangleView
            if (backgroundView == nil) {
                backgroundView = RoundedRectangleView(frame: bounds, configuration: configuration)
                backgroundView?.layer?.edgeAntialiasingMask = .all
                super.contentView = backgroundView
            }

            if (self.childContentView != nil) {
                self.childContentView?.removeFromSuperview()
            }

            childContentView = newValue
            childContentView?.translatesAutoresizingMaskIntoConstraints = false
            childContentView?.wantsLayer = true
            childContentView?.layer?.cornerRadius = configuration.cornerRadius
            childContentView?.layer?.masksToBounds = true
            childContentView?.layer?.edgeAntialiasingMask = .all

            guard let userContentView = self.childContentView, let backgroundView = self.backgroundView else { return }
            backgroundView.addSubview(userContentView)

            let contentEdgeInsets = NSEdgeInsets.zero//configuration.contentEdgeInsets
            let borderWidth: CGFloat = 0
            let left = borderWidth + contentEdgeInsets.left
            let right = borderWidth + contentEdgeInsets.right
            let top = borderWidth + contentEdgeInsets.top
            let bottom = borderWidth + contentEdgeInsets.bottom

            NSLayoutConstraint.activate([
                userContentView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: left),
                userContentView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -right),
                userContentView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: top),
                userContentView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -bottom)
            ])
        }

        get {
            childContentView
        }
    }

    override func frameRect(forContentRect contentRect: NSRect) -> NSRect {
        NSMakeRect(NSMinX(contentRect), NSMinY(contentRect), NSWidth(contentRect), NSHeight(contentRect))
    }
}
