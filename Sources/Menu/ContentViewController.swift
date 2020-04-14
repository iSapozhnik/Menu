//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 10.04.20.
//

import Cocoa

protocol ContentViewControllerDelegate: AnyObject {
    func didClickMenuElement(with index: Int)
}

class ContentViewController: NSViewController {
    weak var delegate: ContentViewControllerDelegate?

    private let titleString: String?
    private let menuItems: [MenuItem]
    private let configuration: Configuration

    private var menuElements = [NSView]()
    private var slectedIndex: Int = .defaultSelectedIndex

    private let stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0.0
        return stackView
    }()

    init(with titleString: String?, menuItems: [MenuItem], selectedIndex: Int, configuration: Configuration) {
        self.titleString = titleString
        self.menuItems = menuItems
        self.slectedIndex = selectedIndex
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var titleLabel: NSTextField? = nil
        if let title = titleString {
            let label = makeLabel(with: title)
            view.addSubview(label)
            titleLabel = label

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: configuration.contentEdgeInsets.left),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -configuration.contentEdgeInsets.right),
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: configuration.titlePadding.top),
            ])
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        if let titleLabel = titleLabel {
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: configuration.titlePadding.bottom).isActive = true
        } else {
            stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }

        menuItems.enumerated().forEach { index, item in
            if item.isSeparator {
                addSeparator()
            } else {
                addMenuElement(with: item, isSelected: index == slectedIndex)
            }
        }
    }

    private func addSeparator() {
        let separatorContainer = NSView()
        separatorContainer.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(separatorContainer)

        let separator = NSView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.wantsLayer = true
        separator.layer?.backgroundColor = configuration.separatorColor.cgColor
        separatorContainer.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: separatorContainer.topAnchor, constant: configuration.separatorVerticlaPadding.top),
            separator.bottomAnchor.constraint(equalTo: separatorContainer.bottomAnchor, constant: -configuration.separatorVerticlaPadding.bottom),
            separator.leadingAnchor.constraint(equalTo: separatorContainer.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: separatorContainer.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: configuration.separatorThickness),
            separatorContainer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: configuration.separatorHorizontalPadding.left),
            separatorContainer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -configuration.separatorHorizontalPadding.right),
        ])

        menuElements.append(separatorContainer)
    }

    private func addMenuElement(with menuItem: MenuItem, isSelected: Bool) {
        let menuElement = MenuElement(
            text: menuItem.title,
            image: menuItem.image,
            isSelected: isSelected,
            configuration: configuration,
            action: menuItem.action
        )
        menuElement.translatesAutoresizingMaskIntoConstraints = false
        menuElement.delegate = self
        menuElement.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(menuElement)

        NSLayoutConstraint.activate([
            menuElement.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            menuElement.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])

        menuElements.append(menuElement)
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
        label.font = configuration.titleFont
        label.textColor = configuration.menuItemTextColor
        switch configuration.textAlignment {
        case .left:
            label.alignment = .left
        case .right:
            label.alignment = .right
        }
        return label
    }
}

extension ContentViewController: MenuElementDelegate {
    func didClickMenuElement(_ menuElement: MenuElement) {
        let index = menuElements.firstIndex(of: menuElement)
        slectedIndex = index ?? .defaultSelectedIndex
        delegate?.didClickMenuElement(with: slectedIndex)
    }
}
