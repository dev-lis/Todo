//
//  TodoListCell.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import AppUIKit
import UIKit

final class TodoListCell: UITableViewCell {

    static let reuseId = "TodoListCell"

    private lazy var iconButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleCompletion), for: .touchUpInside)
        return button
    }()

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Font.body
        label.textColor = UI.Color.textRegular
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Font.footer
        label.textColor = UI.Color.textRegular
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Font.footer
        label.textColor = UI.Color.textDisabled
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UI.Color.textSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var item: TodoDisplayItem?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(iconButton)
        contentView.addSubview(contentStackView)
        contentView.addSubview(separatorView)

        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(dateLabel)

        NSLayoutConstraint.activate([
            iconButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconButton.widthAnchor.constraint(equalToConstant: 24),
            iconButton.heightAnchor.constraint(equalToConstant: 24),

            contentStackView.leadingAnchor.constraint(equalTo: iconButton.trailingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -12),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    // MARK: - Configure

    func configure(with item: TodoDisplayItem) {
        self.item = item

        titleLabel.text = item.title
        titleLabel.isStrikethrough = item.isCompleted

        descriptionLabel.text = item.description
        descriptionLabel.isHidden = item.description == nil || item.description?.isEmpty == true

        dateLabel.text = item.date

        let icon = item.isCompleted
        ? UI.Image.checkmarkCircle
        : UI.Image.circle
        iconButton.setImage(icon, for: .normal)

        iconButton.tintColor = item.isCompleted
        ? UI.Color.brandPrimary
        : UI.Color.textDisabled

        let alpha: CGFloat = item.isCompleted ? 0.5 : 1
        titleLabel.alpha = alpha
        descriptionLabel.alpha = alpha
        dateLabel.alpha = alpha
    }

    @objc func toggleCompletion() {
        item?.toggleCompletion()
    }
}
