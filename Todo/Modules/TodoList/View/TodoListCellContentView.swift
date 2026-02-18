//
//  TodoListCellContentView.swift
//  Todo
//

import AppUIKit
import UIKit

final class TodoListCellContentView: UIView {

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Font.body
        label.textColor = UI.Color.textRegular
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Font.footer
        label.textColor = UI.Color.textRegular
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Font.footer
        label.textColor = UI.Color.textDisabled
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UI.Color.textSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(contentStackView)
        addSubview(separatorView)

        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(dateLabel)

        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor),

            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    func configure(title: String, description: String?, date: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil || description?.isEmpty == true
        dateLabel.text = date
    }

    func setCompletedStyle(isCompleted: Bool) {
        titleLabel.isStrikethrough = isCompleted
        let alpha: CGFloat = isCompleted ? 0.5 : 1
        titleLabel.alpha = alpha
        descriptionLabel.alpha = alpha
        dateLabel.alpha = alpha
    }
}
