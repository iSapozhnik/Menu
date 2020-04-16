//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 12.04.20.
//

import Cocoa

protocol MenuElementDelegate: AnyObject {
    func didClickMenuElement(_ menuElement: MenuElement)
}

class MenuElement: NSView {
    let handler: () -> Void
    weak var delegate: MenuElementDelegate?
    private let configuration: Configuration
    private var checkmark: CheckmarkView!

    init(text: String, image: NSImage? = nil, isSelected: Bool = false, configuration: Configuration, action: @escaping () -> Void) {
        self.configuration = configuration
        handler = action

        super.init(frame: .zero)

        let stackView = makeHorizontalStackView()

        var lImageView: NSImageView? = nil
        var rImageView: NSImageView? = nil
        switch configuration.iconAlignment {
        case .left:
            lImageView = makeLeftImageView(with: image)
        case .right:
            rImageView = makeRightImageView(with: image)
        }

        let label = makeLabel(with: text)

        if let lImageView = lImageView {
            stackView.addArrangedSubview(lImageView)
            NSLayoutConstraint.activate([
                lImageView.heightAnchor.constraint(equalTo: lImageView.widthAnchor, multiplier: 1.0),
                lImageView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            ])
            lImageView.heightAnchor.constraint(equalToConstant: configuration.menuItemImageHeight ?? 0.0).isActive = configuration.menuItemImageHeight != nil
        }
        stackView.addArrangedSubview(label)

        if let rImageView = rImageView {
            stackView.addArrangedSubview(rImageView)
            NSLayoutConstraint.activate([
                rImageView.heightAnchor.constraint(equalTo: rImageView.widthAnchor, multiplier: 1.0),
                rImageView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            ])
            rImageView.heightAnchor.constraint(equalToConstant: configuration.menuItemImageHeight ?? 0.0).isActive = configuration.menuItemImageHeight != nil
        }

        if configuration.rememberSelection {
            let checkmarkView = CheckmarkView(with: configuration)
            checkmarkView.translatesAutoresizingMaskIntoConstraints = false

            switch configuration.iconAlignment {
            case .left:
                stackView.addArrangedSubview(checkmarkView)
            case .right:
                stackView.insertArrangedSubview(checkmarkView, at: 0)
            }

            if isSelected {
                checkmarkView.animate(duration: 0)
            }
            checkmark = checkmarkView
        }

        let control = makeHoverControl(update: label, leftImageView: lImageView, rightImageView: rImageView)

        addSubview(control)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: configuration.menuItemHeight),

            control.leadingAnchor.constraint(equalTo: leadingAnchor),
            control.trailingAnchor.constraint(equalTo: trailingAnchor),
            control.topAnchor.constraint(equalTo: topAnchor),
            control.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: configuration.contentEdgeInsets.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -configuration.contentEdgeInsets.right),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        if configuration.rememberSelection, let checkmarkView = checkmark {
            NSLayoutConstraint.activate([
                checkmarkView.heightAnchor.constraint(equalTo: checkmarkView.widthAnchor, multiplier: 1.0),
                checkmarkView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
                checkmarkView.widthAnchor.constraint(equalToConstant: configuration.menuItemCheckmarkHeight)
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func menuElementClicked(_ sender: Control) {
        handler()
        delegate?.didClickMenuElement(self)
    }

    private func makeHorizontalStackView() -> NSStackView {
        let stackView = NSStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.orientation = .horizontal
        stackView.distribution = .fill
        stackView.spacing = .grid1
        return stackView
    }

    private func makeLabel(with text: String) -> NSTextField {
        let label = NSTextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.cell = VerticallyCenteredTextFieldCell()
        label.cell?.lineBreakMode = .byTruncatingTail
        label.maximumNumberOfLines = 1
        label.backgroundColor = .clear
        label.stringValue = text
        label.isEditable = false
        label.isBordered = false
        label.font = configuration.menuItemFont
        label.textColor = configuration.menuItemTextColor
        switch configuration.textAlignment {
        case .left:
            label.alignment = .left
        case .right:
            label.alignment = .right
        }
        return label
    }

    private func makeRightImageView(with image: NSImage?) -> NSImageView {
        let rImageView = NSImageView()
        rImageView.translatesAutoresizingMaskIntoConstraints = false
        rImageView.image = image
        if #available(OSX 10.14, *) {
            if let menuItemImageTintColor = configuration.menuItemImageTintColor, let image = image, image.isTemplate {
                rImageView.contentTintColor = menuItemImageTintColor
            }
        }
        rImageView.isHidden = image == nil
        return rImageView
    }

    private func makeLeftImageView(with image: NSImage?) -> NSImageView {
        let lImageView = NSImageView()
        lImageView.translatesAutoresizingMaskIntoConstraints = false
        lImageView.imageScaling = .scaleProportionallyUpOrDown
        lImageView.image = image
        if #available(OSX 10.14, *) {
            if let menuItemImageTintColor = configuration.menuItemImageTintColor, let image = image, image.isTemplate {
                lImageView.contentTintColor = menuItemImageTintColor
            }
        }
        lImageView.isHidden = image == nil
        return lImageView
    }

    private func makeHoverControl(update label: NSTextField, leftImageView: NSImageView?, rightImageView: NSImageView?) -> Control {
        let control = Control(with: configuration)
        control.hover = { [weak self] isHover in
            guard let self = self else { return }
            label.textColor = isHover ? self.configuration.menuItemHoverTextColor : self.configuration.menuItemTextColor
            if #available(OSX 10.14, *) {
                leftImageView?.contentTintColor = isHover ? self.configuration.menuItemHoverImageTintColor : self.configuration.menuItemImageTintColor
                rightImageView?.contentTintColor = isHover ? self.configuration.menuItemHoverImageTintColor : self.configuration.menuItemImageTintColor
            }
        }

        control.translatesAutoresizingMaskIntoConstraints = false
        control.target = self
        control.action = #selector(menuElementClicked(_:))
        control.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return control
    }
}

