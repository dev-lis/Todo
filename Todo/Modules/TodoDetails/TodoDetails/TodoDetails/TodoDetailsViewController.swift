//
//  TodoDetailsViewController.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//

import AppUIKit
import UIKit

protocol ITodoDetailsView: AnyObject {
    func display(title: String, date: String, description: String)
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
        stack.alignment = .leading
        return stack
    }()

    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UI.Font.header
        textView.textColor = UI.Color.textRegular
        textView.backgroundColor = .clear
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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

        headStack.addArrangedSubview(titleTextView)
        headStack.addArrangedSubview(dateLabel)
        contentStack.addArrangedSubview(headStack)
        contentStack.addArrangedSubview(descriptionTextView)

        setupConstraints()
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
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])
    }
}

// MARK: - ITodoDetailsView

extension TodoDetailsViewController: ITodoDetailsView {
    func display(title: String, date: String, description: String) {
        titleTextView.text = title
        dateLabel.text = date
        descriptionTextView.text = description
    }
}
