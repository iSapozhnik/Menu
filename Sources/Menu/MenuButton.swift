//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 16.04.20.
//

import Cocoa

public class MenuButton: NSButton, CALayerDelegate {
    private var containerLayer = CALayer()
    private var titleLayer = CATextLayer()

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: NSRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        wantsLayer = true
        layer?.masksToBounds = false

        layer?.cornerRadius = 4
        layer?.borderWidth = 1
        layer?.delegate = self

        titleLayer.delegate = self
        if let scale = window?.backingScaleFactor {
            titleLayer.contentsScale = scale
        }

        containerLayer.masksToBounds = false
        containerLayer.shadowOffset = NSSize.zero
        containerLayer.shadowColor = NSColor.clear.cgColor
        containerLayer.frame = NSMakeRect(0, 0, bounds.width, bounds.height)

        containerLayer.addSublayer(titleLayer)
        layer?.addSublayer(containerLayer)

        setupTitle()
    }

    func setupTitle() {
        guard let font = font else { return }
        titleLayer.string = title
        titleLayer.font = font
        titleLayer.fontSize = font.pointSize

        let attributes = [NSAttributedString.Key.font: font as Any]
        let titleSize = title.size(withAttributes: attributes)
        var titleRect = NSMakeRect(0, 0, titleSize.width, titleSize.height)

        titleRect.origin.y = round((bounds.height - titleSize.height)/2)
        titleRect.origin.x = round((bounds.width - titleSize.width)/2)

        titleLayer.frame = titleRect
    }
}
