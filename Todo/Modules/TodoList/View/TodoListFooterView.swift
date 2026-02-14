//
//  TodoListFooterView.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//

import UIKit

final class TodoListFooterView: UIView {
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .todoText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .todoAccent
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .todoStroke
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
        addSubview(blurView)
        addSubview(dividerView)
        addSubview(countLabel)
        addSubview(addButton)

        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),

            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),

            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28),

            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
    }
}
