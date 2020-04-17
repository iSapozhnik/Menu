//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 13.04.20.
//

import Cocoa

final class CheckmarkView: NSView {
    private var checkmarkLayer = CAShapeLayer()
    private let configuration: Configuration
    private var animationCompletion: (() -> Void)?

    init(with configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()
        checkmarkLayer.path = makeCheckmarkPath()
    }

    override var isFlipped: Bool {
        return true
    }

    private func configureView() {
        wantsLayer = true

        checkmarkLayer.fillColor = NSColor.clear.cgColor
        checkmarkLayer.lineWidth = configuration.menuItemCheckmarkThikness
        checkmarkLayer.path = makeCheckmarkPath()
        checkmarkLayer.strokeEnd = 0
        checkmarkLayer.strokeColor = configuration.menuItemCheckmarkColor.cgColor
        checkmarkLayer.lineCap = CAShapeLayerLineCap.round
        checkmarkLayer.lineJoin = CAShapeLayerLineJoin.round
        layer?.addSublayer(checkmarkLayer)
    }

    public func animate(duration: TimeInterval = 0.15, with completion: (() -> Void)? = nil) {
        guard duration != 0 else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            checkmarkLayer.strokeEnd = 1
            CATransaction.commit()
            completion?()
            return
        }
        animationCompletion = completion
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.delegate = self
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = .easeInEaseOut
        animation.duration = duration
        animation.isRemovedOnCompletion = false

        checkmarkLayer.strokeEnd = 1
        checkmarkLayer.add(animation, forKey: "animateCheckmark")
    }

    private func makeCheckmarkPath() -> CGPath {
        let scale = bounds.width / 100
        let centerX = bounds.size.width / 2
        let centerY = bounds.size.height / 2

        let path = CGMutablePath()
        let center     = CGPoint(x: centerX, y: centerY)
        let startAngle = CGFloat(Double.pi)
        let endAngle   = CGFloat(Double.pi) * 5

        path.addArc(center: center, radius: centerX, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.move(to: CGPoint(x: centerX - 23 * scale, y: centerY - 1 * scale))
        path.addLine(to: CGPoint(x: centerX - 6 * scale, y: centerY + 15.9 * scale))
        path.addLine(to: CGPoint(x: centerX + 22.8 * scale, y: centerY - 13.4 * scale))
        return path
    }
}

extension CheckmarkView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationCompletion?()
    }
}
