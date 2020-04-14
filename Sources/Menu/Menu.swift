//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 10.04.20.
//

import Cocoa
import EventMonitor

public final class Menu {
    private var window: Window?
    private var lostFocusObserver: Any?
    private var localMonitor: EventMonitor?
    private let configuration: Configuration
    private var selectedIndex: Int = .defaultSelectedIndex
    private let title: String?

    public convenience init() {
        self.init(with: nil)
    }

    public init(with title: String?, configuration: Configuration = MenuConfiguration()) {
        self.title = title
        self.configuration = configuration
    }

    public func show(items: [MenuItem], view: NSView) {
        guard window == nil, let parentWindow = view.window else { return }

        let contentViewController = ContentViewController(with: title, menuItems: items, selectedIndex: selectedIndex, configuration: configuration)
        contentViewController.delegate = self

        let window = Window.make(with: configuration)
        window.contentViewController = contentViewController
        view.window?.addChildWindow(window, ordered: .above)

        self.window = window
        setPositionRelativeTo(view)

        setupMonitors(for: parentWindow, targetView: view)

        fadeIn(window)
    }

    public func dismiss(animated: Bool) {
        let actualDismiss: (NSWindow) -> Void = { [weak self] menuWindow in
            self?.window?.parent?.removeChildWindow(menuWindow)
            self?.window?.orderOut(self)
            self?.window = nil
        }
        if let menuWindow = window {
            if animated {
                fadeOut(window: menuWindow) {
                    actualDismiss(menuWindow)
                }
            } else {
                actualDismiss(menuWindow)
            }
        }

        localMonitor?.stop()
        localMonitor = nil

        if let lostFocusObserver = lostFocusObserver {
            NotificationCenter.default.removeObserver(lostFocusObserver)
            self.lostFocusObserver = nil
        }
    }

    private func fadeIn(_ window: NSWindow) {
        window.alphaValue = 0.0

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            window.animator().alphaValue = 1.0
        }
    }

    private func fadeOut(window: NSWindow, completion: @escaping () -> Void) {
        NSAnimationContext.runAnimationGroup ({ context in
            context.duration = 0.15
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window.animator().alphaValue = 0.0
        }, completionHandler: {
            completion()
        })
    }

    private func setupMonitors(for parentWindow: NSWindow, targetView: NSView) {
        lostFocusObserver = NotificationCenter.default.addObserver(forName: NSWindow.didResignKeyNotification, object: parentWindow, queue: nil, using: { [weak self] (_ arg1: Notification) -> Void in
            self?.dismiss(animated: false)
        })

        localMonitor = EventMonitor(monitorType: .local, mask: [.leftMouseDown, .rightMouseDown, .otherMouseDown], globalHandler: nil, localHandler: { [weak self] event -> NSEvent? in
            guard let localEvent = event else { return event }

            if localEvent.window != self?.window {
                if localEvent.window == parentWindow {
                    self?.dismiss(animated: true)
//                    Ignore clicking on presenting view
//                    let contentView = parentWindow.contentView
//                    let locationTest = contentView?.convert(localEvent.locationInWindow, from: nil)
//                    let hitView = contentView?.hitTest(locationTest ?? .zero)
//                    if hitView != targetView {
//                        self?.dismiss()
//                    }
                }
            }
            return localEvent
        })
        localMonitor?.start()
    }

    private func setPositionRelativeTo(_ view: NSView) {
        guard let presentationWindow = view.window, let window = self.window else { return }

        let presentationFrame = presentationWindow.convertToScreen(view.frame)
        let presentationPoint = presentationFrame.origin
        let additionalYOffset = configuration.appearsBelowSender ? 0 : NSHeight(view.frame)

        let newFrame = NSRect(x: presentationPoint.x, y: presentationPoint.y - NSHeight(window.frame) + additionalYOffset, width: NSWidth(view.frame), height: NSHeight(window.frame))
        window.setFrame(newFrame, display: true, animate: false)
    }
}

extension Menu: ContentViewControllerDelegate {
    func didClickMenuElement(with index: Int) {
        selectedIndex = index
        dismiss(animated: true)
    }
}
