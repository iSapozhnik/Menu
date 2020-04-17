//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 15.04.20.
//

import Cocoa

enum MenuScrollerType {
    case horizontal
    case vertical
}

class MenuScroller: NSScroller {
    override var floatValue: Float {
        get {
            return super.floatValue
        }
        set {
            super.floatValue = newValue
            updateAlpha(1.0, animated: true)
            rescheduleFadeOut()
        }
    }

    private var alpha: CGFloat = 0.0
    private var type: MenuScrollerType = .vertical
    private var trackingArea: NSTrackingArea!

    init(withType scrollerType: MenuScrollerType) {
        type = scrollerType
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    func commonInit() {
        trackingArea = NSTrackingArea.init(rect: bounds, options: [.mouseEnteredAndExited, .activeInActiveApp, .mouseMoved], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }

    @objc func fadeOut() {
        updateAlpha(0.3, animated: true, anumationDuration: 0.25)
    }

    override func draw(_ dirtyRect: NSRect) {
        self.drawKnob()
        self.drawKnobSlot(in: bounds, highlight: false)
    }

    override func drawKnob() {
        NSColor.white.setFill()

        let dx, dy: CGFloat
        switch type {
        case .horizontal:
            dx = 0; dy = 3
        case .vertical:
            dx = 5; dy = 0
        }

        let frame = rect(for: .knob).insetBy(dx: dx, dy: dy)
        NSBezierPath.init(roundedRect: frame, xRadius: 3, yRadius: 3).fill()
    }

    override func updateTrackingAreas() {
        if trackingAreas.contains(trackingArea) {
            removeTrackingArea(trackingArea)
        }

        trackingArea = NSTrackingArea.init(rect: bounds, options: [.mouseEnteredAndExited, .activeInActiveApp, .mouseMoved], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }

    override func drawKnobSlot(in slotRect: NSRect, highlight flag: Bool) {
        NSColor.init(white: 1.0, alpha: 0.15).setFill()
        let frame = rect(for: .knobSlot).insetBy(dx: 3, dy: 0)
        NSBezierPath.init(roundedRect: frame, xRadius: 5, yRadius: 5).fill()
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.fadeOut()
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        updateAlpha(1.0, animated: true)
        cancelPreviuousFadeOut()
    }

    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        updateAlpha(1.0, animated: false)
    }

    private func rescheduleFadeOut() {
        cancelPreviuousFadeOut()
        perform(#selector(fadeOut), with: nil, afterDelay: 1.0)
    }

    private func cancelPreviuousFadeOut() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fadeOut), object: nil)
    }

    private func updateAlpha(_ newAlpha: CGFloat, animated: Bool, anumationDuration duration: TimeInterval = 0.1) {
        guard alpha != newAlpha else { return }

        alpha = newAlpha
        if animated {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = duration
                animator().alphaValue = newAlpha
            }
        } else {
            alphaValue = newAlpha
        }
    }
}
