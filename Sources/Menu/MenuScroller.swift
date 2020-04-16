//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 15.04.20.
//

import Cocoa

class MenuScroller: NSScroller {

    // MARK: -
    // MARK: Variables

    override var floatValue: Float {
        get {
            return super.floatValue
        }
        set {
            super.floatValue = newValue
            animator().alphaValue = 1.0
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fadeOut), object: nil)
            perform(#selector(fadeOut), with: nil, afterDelay: 1.0)
        }
    }

    // MARK: -
    // MARK: Initialization

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.initialize()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }

    func initialize() {
        let trackingArea = NSTrackingArea.init(rect: self.bounds,
                                               options: [.mouseEnteredAndExited, .activeInActiveApp, .mouseMoved],
                                               owner: self,
                                               userInfo: nil)
        self.addTrackingArea(trackingArea)
    }

    // MARK: -
    // MARK: Custom Methods

    @objc func fadeOut() {
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.25
            self.animator().alphaValue = 0.3
        }) {}
    }

    // MARK: -
    // MARK: NSView Method Overrides

    override func draw(_ dirtyRect: NSRect) {
        // Only draw the knob. drawRect: should only be invoked when overlay scrollers are not used
        self.drawKnob()
        self.drawKnobSlot(in: bounds, highlight: false)
    }

    // MARK: -
    // MARK: - NSScroller Method Overrides

    override func drawKnob() {
        NSColor.white.setFill()

        let dx, dy: CGFloat
//        if isHorizontal {
//            dx = 0; dy = 3
//        } else {
            dx = 5; dy = 0
//        }

        let frame = rect(for: .knob).insetBy(dx: dx, dy: dy)
        NSBezierPath.init(roundedRect: frame, xRadius: 3, yRadius: 3).fill()
    }

    override func drawKnobSlot(in slotRect: NSRect, highlight flag: Bool) {
        // Don't draw the background. Should only be invoked when using overlay scrollers
        NSColor.init(white: 1.0, alpha: 0.15).setFill()
        let frame = rect(for: .knobSlot).insetBy(dx: 3, dy: 0)
        NSBezierPath.init(roundedRect: frame, xRadius: 5, yRadius: 5).fill()

    }

    // MARK: -
    // MARK: NSResponder Method Overrides

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.fadeOut()
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.1
            self.animator().alphaValue = 1.0
        }) {}
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fadeOut), object: nil)
    }

    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        self.alphaValue = 1.0 //TODO prevent multiple calls
    }
}
