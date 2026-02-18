//
//  TodoDetailsViewController.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//

import AppUIKit
import UIKit

protocol ITodoDetailsView: AnyObject {
    func update(item: TodoDetailsDisplayItem)
}

final class TodoDetailsViewController: UIViewController {

    var presenter: ITodoDetailsPresenter

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let headStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        return stack
    }()

    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UI.Font.header
        textView.textColor = UI.Color.textRegular
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var titlePlaceholderLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Font.header
        label.textColor = UI.Color.textSecondary
        label.numberOfLines = 0
        label.text = L.titlePlaceholder.localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UI.Font.footer
        label.textColor = UI.Color.textRegular.withAlphaComponent(0.5)
        label.numberOfLines = 1
        return label
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = UI.Color.textRegular
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UI.Color.textSecondary
        label.numberOfLines = 0
        label.text = L.descriptionPlaceholder.localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(presenter: ITodoDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
}

// MARK: - Setup

private extension TodoDetailsViewController {
    func setupUI() {
        view.backgroundColor = UI.Color.baseBackground
        setupNavigationBar()

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        titleTextView.delegate = self
        descriptionTextView.delegate = self

        headStack.addArrangedSubview(titleTextView)
        headStack.addArrangedSubview(dateLabel)
        contentStack.addArrangedSubview(headStack)
        contentStack.addArrangedSubview(descriptionTextView)

        titleTextView.addSubview(titlePlaceholderLabel)
        descriptionTextView.addSubview(descriptionPlaceholderLabel)

        setupConstraints()
        updatePlaceholdersVisibility()
    }

    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UI.Color.baseBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UI.Color.textRegular,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        let navBar = navigationController?.navigationBar
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        navBar?.compactAppearance = appearance
        navBar?.tintColor = UI.Color.brandPrimary

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: L.save.localized(),
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }

    @objc private func saveButtonTapped() {
        view.endEditing(true)
        presenter.didTapSave()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),

            titlePlaceholderLabel.topAnchor.constraint(equalTo: titleTextView.topAnchor),
            titlePlaceholderLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            titlePlaceholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: titleTextView.trailingAnchor),

            descriptionPlaceholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor),
            descriptionPlaceholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor),
            descriptionPlaceholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: descriptionTextView.trailingAnchor)
        ])
    }

    func updatePlaceholdersVisibility() {
        titlePlaceholderLabel.isHidden = !(titleTextView.text ?? "").isEmpty
        descriptionPlaceholderLabel.isHidden = !(descriptionTextView.text ?? "").isEmpty
    }
}

// MARK: - ITodoDetailsView

extension TodoDetailsViewController: ITodoDetailsView {
    func update(item: TodoDetailsDisplayItem) {
        titleTextView.text = item.title
        dateLabel.text = item.date
        descriptionTextView.text = item.description
        updatePlaceholdersVisibility()
    }
}

// MARK: - UITextViewDelegate

extension TodoDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholdersVisibility()
        if textView === titleTextView {
            presenter.didChangeTitle(textView.text ?? "")
        } else if textView === descriptionTextView {
            presenter.didChangeDescription(textView.text ?? "")
        }
    }
}
