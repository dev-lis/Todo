//
//  TodoListFooterView.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import AppUIKit
import UIKit

final class TodoListFooterView: UIView {
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Font.footer
        label.textColor = UI.Color.textRegular
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UI.Image.squareAndPencil, for: .normal)
        button.tintColor = UI.Color.brandPrimary
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UI.Color.textSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCounterText(_ text: String) {
        countLabel.text = text
    }
}

private extension TodoListFooterView {
    func setupUI() {
        backgroundColor = UI.Color.secondaryBackground

        addSubview(dividerView)
        addSubview(countLabel)
        addSubview(addButton)

        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),

            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28),

            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
    }
}
