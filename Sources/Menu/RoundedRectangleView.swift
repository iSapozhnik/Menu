//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 10.04.20.
//

import Cocoa

final class RoundedRectangleView: NSView {
    private let configuration: Configuration

    init(frame frameRect: NSRect, configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let backgroundRect = NSMakeRect(NSMinX(bounds), NSMinY(bounds), NSWidth(bounds), NSHeight(bounds))

        let cornerRadius = configuration.cornerRadius
        let windowPath = NSBezierPath()
        let backgroundPath = NSBezierPath(roundedRect: backgroundRect, xRadius: cornerRadius, yRadius: cornerRadius)
        windowPath.append(backgroundPath)

        configuration.backgroundColor.setFill()
        windowPath.fill()
    }

    override var frame: NSRect {
        didSet {
            setNeedsDisplay(frame)
        }
    }
}

