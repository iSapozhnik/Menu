//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 10.04.20.
//

import Cocoa

extension CAEdgeAntialiasingMask {
    static let all: CAEdgeAntialiasingMask = [.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge]
}

// https://gist.github.com/BenLeggiero/1ec89e5979bf88ca13e2393fdab15ecc

private let defaultWindowAnimationDuration: TimeInterval = 0.25

public extension NSWindow {

    /// Called when an animation completes
    typealias AnimationCompletionHandler = () -> Void



    /// Represents a function called to make a window be presented
    enum PresentationFunction {
        /// Calls `NSWindow.makeKey()`
        case makeKey

        /// Calls `NSWindow.makeKeyAndOrderFront(_:)`
        case makeKeyAndOrderFront

        /// Calls `NSWindow.orderFront(_:)`
        case orderFront

        /// Calls `NSWindow.orderFrontRegardless()`
        case orderFrontRegardless


        /// Runs the function represented by this case on the given window, passing the given selector if needed
        public func run(on window: NSWindow, sender: Any?) {
            switch self {
            case .makeKey: window.makeKey()
            case .makeKeyAndOrderFront: window.makeKeyAndOrderFront(sender)
            case .orderFront: window.orderFront(sender)
            case .orderFrontRegardless: window.orderFrontRegardless()
            }
        }
    }



    /// Represents a function called to make a window be closed
    enum CloseFunction {
        /// Calls `NSWindow.orderOut(_:)`
        case orderOut

        /// Calls `NSWindow.close()`
        case close

        /// Calls `NSWindow.performClose()`
        case performClose


        /// Runs the function represented by this case on the given window, passing the given selector if needed
        public func run(on window: NSWindow, sender: Any?) {
            switch self {
            case .orderOut: window.orderOut(sender)
            case .close: window.close()
            case .performClose: window.performClose(sender)
            }
        }
    }



    /// Fades this window in using the default values. Useful for NIB-style actions
    @IBAction
    func fadeIn(_ sender: Any?) {
        self.fadeIn(sender: sender, duration: defaultWindowAnimationDuration)
    }


    /// Fades this window in using the given configuration
    ///
    /// - Parameters:
    ///   - sender:               The message's sender, if any
    ///   - duration:             The minimum amount of time it should to fade the window in
    ///   - timingFunction:       The timing function of the animation
    ///   - startingAlpha:        The alpha value at the start of the animation
    ///   - targetAlpha:          The alpha value at the end of the animation
    ///   - presentationFunction: The function to use when initially presenting the window
    ///   - completionHandler:    Called when the animation completes
    func fadeIn(sender: Any?,
                       duration: TimeInterval,
                       timingFunction: CAMediaTimingFunction? = .default,
                       startingAlpha: CGFloat = 0,
                       targetAlpha: CGFloat = 1,
                       presentationFunction: PresentationFunction = .makeKeyAndOrderFront,
                       completionHandler: AnimationCompletionHandler? = nil) {

        alphaValue = startingAlpha

        presentationFunction.run(on: self, sender: sender)

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            context.timingFunction = timingFunction
            animator().alphaValue = targetAlpha
        }, completionHandler: completionHandler)
    }


    /// Fades this window out using the default values. Useful for NIB-style actions
    @IBAction func fadeOut(_ sender: Any?) {
        self.fadeOut(sender: sender, duration: defaultWindowAnimationDuration)
    }


    /// Fades this window out using the given configuration
    ///
    /// - Note: Unlike `fadeIn`, this does not take a starting alpha value. This is because the window's current
    ///         alpha is used. If you really want it to be different, simply change that immediately before calling
    ///         this function.
    ///
    /// - Parameters:
    ///   - sender:               The message's sender, if any
    ///   - duration:             The minimum amount of time it should to fade the window out
    ///   - timingFunction:       The timing function of the animation
    ///   - targetAlpha:          The alpha value at the end of the animation
    ///   - presentationFunction: The function to use when initially presenting the window
    ///   - completionHandler:    Called when the animation completes
    func fadeOut(sender: Any?,
                 duration: TimeInterval,
                 timingFunction: CAMediaTimingFunction? = .default,
                 targetAlpha: CGFloat = 0,
                 resetAlphaAfterAnimation: Bool = true,
                 closeSelector: CloseFunction = .orderOut,
                 completionHandler: AnimationCompletionHandler? = nil) {

        let startingAlpha = self.alphaValue

        NSAnimationContext.runAnimationGroup({ context in

            context.duration = duration
            context.timingFunction = timingFunction
            animator().alphaValue = targetAlpha

        }, completionHandler: { [weak weakSelf = self] in
            guard let weakSelf = weakSelf else { return }

            closeSelector.run(on: weakSelf, sender: sender)

            if resetAlphaAfterAnimation {
                weakSelf.alphaValue = startingAlpha
            }

            completionHandler?()
        })
    }
}

public extension CAMediaTimingFunction {
    static let easeIn = CAMediaTimingFunction(name: .easeIn)
    static let easeOut = CAMediaTimingFunction(name: .easeOut)
    static let easeInEaseOut = CAMediaTimingFunction(name: .easeInEaseOut)
    static let linear = CAMediaTimingFunction(name: .linear)
    static let `default` = CAMediaTimingFunction(name: .default)
}

extension NSEdgeInsets {
    static let zero = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}

extension CGFloat {
    /// 0 points
    static let grid0: CGFloat = 0.0
    /// 4 points
    static let gridHalf: CGFloat = 4.0
    /// 8 points
    static let grid1: CGFloat = 8.0
    /// 16 points
    static let grid2: CGFloat = 16.0
    /// 24 points
    static let grid3: CGFloat = 24.0
    /// 32 points
    static let grid4: CGFloat = 32.0
    /// 40 points
    static let grid5: CGFloat = 40.0
    /// 48 points
    static let grid6: CGFloat = 48.0
}
