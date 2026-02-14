//
//  TodoListCell.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//

import UIKit

final class TodoListCell: UITableViewCell {

    static let reuseId = "TodoListCell"

    // MARK: - UI Components

    private let iconButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.tintColor = .todoText.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .todoText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .todoText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .todoText.withAlphaComponent(0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .todoStroke
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

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

    func configure(with item: TodoItemDisplay) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        descriptionLabel.isHidden = item.description == nil || item.description?.isEmpty == true
        dateLabel.text = item.date
        iconButton.isSelected = item.isCompleted

        let alpha: CGFloat = item.isCompleted ? 0.5 : 1
        titleLabel.alpha = alpha
        descriptionLabel.alpha = alpha
        dateLabel.alpha = alpha
    }
}
