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
    private var trackingArea: NSTrackingArea?
    private let configuration: Configuration

    init(with configuration: Configuration) {
        self.configuration = configuration
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
        let newRect = bounds.inset(by: configuration.menuItemHoverEdgeInsets)
        hoverLayer.path = CGPath(roundedRect: newRect, cornerWidth: configuration.menuItemHoverCornerRadius, cornerHeight: configuration.menuItemHoverCornerRadius, transform: nil)

        if let trackingArea = trackingArea, trackingAreas.contains(trackingArea) {
            removeTrackingArea(trackingArea)
        }
        createTrackingArea()
    }

    private func createTrackingArea() {
        let newTrackingArea = NSTrackingArea.init(rect: bounds, options: [.mouseEnteredAndExited, .activeInActiveApp], owner: self, userInfo: nil)
        addTrackingArea(newTrackingArea)
        trackingArea = newTrackingArea
    }

    override func mouseUp(with event: NSEvent) {
        guard isEnabled else { return }
        if let action = action {
            hoverLayer.fillColor = .clear
            hover?(false)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                NSApp.sendAction(action, to: self.target, from: self)
            }
        }
    }

    override func mouseEntered(with event: NSEvent) {
        guard isEnabled else { return }
        animateFillColor(from: .clear, to: configuration.menuItemHoverBackgroundColor)
        hover?(true)
    }

    override func mouseExited(with event: NSEvent) {
        guard isEnabled else { return }
        animateFillColor(from: configuration.menuItemHoverBackgroundColor, to: .clear)
        hover?(false)
    }

    override func draw(_ dirtyRect: NSRect) {
        NSColor.clear.setFill()
        NSBezierPath(rect: bounds).fill()
    }

    private func animateFillColor(from oldColor: NSColor, to newColor: NSColor) {
        let animation = CABasicAnimation(keyPath: "fillColor")
        animation.duration = configuration.menuItemHoverAnimationDuration
        animation.fromValue = oldColor.cgColor
        animation.toValue = newColor.cgColor
        animation.fillMode = .both
        animation.timingFunction = .easeInEaseOut
        animation.isRemovedOnCompletion = false
        hoverLayer.add(animation, forKey: "fillColor")
    }
}
