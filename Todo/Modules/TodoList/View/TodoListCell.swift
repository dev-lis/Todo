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

    private lazy var cellContentView: TodoListCellContentView = {
        let view = TodoListCellContentView()
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
        contentView.addSubview(cellContentView)

        NSLayoutConstraint.activate([
            iconButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconButton.widthAnchor.constraint(equalToConstant: 24),
            iconButton.heightAnchor.constraint(equalToConstant: 24),

            cellContentView.leadingAnchor.constraint(equalTo: iconButton.trailingAnchor, constant: 8),
            cellContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cellContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cellContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Configure

    func configure(with item: TodoDisplayItem) {
        self.item = item

        cellContentView.configure(
            title: item.title,
            description: item.description,
            date: item.date
        )
        cellContentView.setCompletedStyle(isCompleted: item.isCompleted)

        let icon = item.isCompleted ? UI.Image.checkmarkCircle : UI.Image.circle
        iconButton.setImage(icon, for: .normal)
        iconButton.tintColor = item.isCompleted ? UI.Color.brandPrimary : UI.Color.textDisabled
    }

    @objc private func toggleCompletion() {
        item?.toggleCompletion()
        item?.isCompleted.toggle()
        let isCompleted = item?.isCompleted ?? false
        cellContentView.setCompletedStyle(isCompleted: isCompleted)
        let icon = isCompleted ? UI.Image.checkmarkCircle : UI.Image.circle
        iconButton.setImage(icon, for: .normal)
        iconButton.tintColor = isCompleted ? UI.Color.brandPrimary : UI.Color.textDisabled
    }
}
