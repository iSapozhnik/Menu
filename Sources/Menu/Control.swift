//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 12.04.20.
//

import Cocoa

class Control: NSControl {
    var hover: ((Bool) -> Void)?

    private let hoverLayer = CAShapeLayer()
    private let configuratuon: Configuration

    init(with configuration: Configuration) {
        self.configuratuon = configuration

        super.init(frame: .zero)
        wantsLayer = true

        hoverLayer.fillColor = .clear
        layer?.addSublayer(hoverLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()

        addTrackingArea(NSTrackingArea.init(rect: bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))

        hoverLayer.path = CGPath(rect: bounds, transform: nil)
    }

    override func mouseUp(with event: NSEvent) {
        if let action = action {
            hoverLayer.fillColor = .clear
            hover?(false)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                NSApp.sendAction(action, to: self.target, from: self)
            }
        }
    }

    override func mouseEntered(with event: NSEvent) {
        hoverLayer.fillColor = configuratuon.menuItemHoverBackgroundColor.cgColor
        hover?(true)
    }

    override func mouseExited(with event: NSEvent) {
        hoverLayer.fillColor = .clear
        hover?(false)
    }

    override func draw(_ dirtyRect: NSRect) {
        NSColor.clear.setFill()
        NSBezierPath(rect: bounds).fill()
    }
}
