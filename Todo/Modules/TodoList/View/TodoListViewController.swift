//
//  TodoListViewController.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//

import UIKit

protocol ITodoListView: AnyObject {
    func update(items: [TodoItemDisplay])
}

final class TodoListViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .todoText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .todoSearchBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var searchIconImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .todoText.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var searchTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Search"
        field.font = .systemFont(ofSize: 17)
        field.textColor = .todoText
        field.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.todoText.withAlphaComponent(0.5)]
        )
        field.backgroundColor = .clear
        field.borderStyle = .none
        field.returnKeyType = .search
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var searchMicButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        let image = UIImage(systemName: "mic.fill", withConfiguration: config)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .todoText.withAlphaComponent(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var footerDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .todoStroke
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tasksCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .todoText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let image = UIImage(systemName: "square.and.pencil", withConfiguration: config)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .todoAccent
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var footerBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var footerBlurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private enum Section: Hashable {
        case main
    }

    private var dataSource: UITableViewDiffableDataSource<Section, TodoItemDisplay>!

    var presenter: ITodoListPresenter

    init(presenter: ITodoListPresenter) {
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Setup

private extension TodoListViewController {
    func setupUI() {
        view.backgroundColor = .todoBackground

        view.addSubview(titleLabel)
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchIconImageView)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(searchMicButton)
        view.addSubview(tableView)
        view.addSubview(footerDivider)
        view.addSubview(footerBackgroundView)
        footerBackgroundView.addSubview(footerBlurView)
        footerBackgroundView.addSubview(tasksCountLabel)
        footerBackgroundView.addSubview(addButton)
        setupConstraints()
        setupTableView()
        presenter.viewDidLoad()
    }

    func createSpacerView(width: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        return view
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            searchContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchContainerView.heightAnchor.constraint(equalToConstant: 36),

            searchIconImageView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 12),
            searchIconImageView.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchIconImageView.widthAnchor.constraint(equalToConstant: 20),
            searchIconImageView.heightAnchor.constraint(equalToConstant: 20),

            searchTextField.leadingAnchor.constraint(equalTo: searchIconImageView.trailingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: searchMicButton.leadingAnchor, constant: -8),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),

            searchMicButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            searchMicButton.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            searchMicButton.widthAnchor.constraint(equalToConstant: 36),
            searchMicButton.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerBackgroundView.topAnchor),

            footerBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerBackgroundView.heightAnchor.constraint(equalToConstant: 84),

            footerDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerDivider.topAnchor.constraint(equalTo: footerBackgroundView.topAnchor),
            footerDivider.heightAnchor.constraint(equalToConstant: 0.5),

            footerBlurView.topAnchor.constraint(equalTo: footerBackgroundView.topAnchor),
            footerBlurView.bottomAnchor.constraint(equalTo: footerBackgroundView.bottomAnchor),
            footerBlurView.leadingAnchor.constraint(equalTo: footerBackgroundView.leadingAnchor),
            footerBlurView.trailingAnchor.constraint(equalTo: footerBackgroundView.trailingAnchor),

            addButton.topAnchor.constraint(equalTo: footerBackgroundView.topAnchor, constant: 12),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28),

            tasksCountLabel.centerXAnchor.constraint(equalTo: footerBackgroundView.centerXAnchor),
            tasksCountLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.reuseId)

        dataSource = UITableViewDiffableDataSource<Section, TodoItemDisplay>(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCell.reuseId, for: indexPath) as? TodoListCell else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            return cell
        }
    }

    func applySnapshot(items: [TodoItemDisplay], animatingDifferences: Bool = true) {
        tasksCountLabel.text = "\(items.count) Задач"
        var snapshot = NSDiffableDataSourceSnapshot<Section, TodoItemDisplay>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - ITodoListView

extension TodoListViewController: ITodoListView {
    func update(items: [TodoItemDisplay]) {
        applySnapshot(items: items)
    }
}

// MARK: - UITableViewDelegate

extension TodoListViewController: UITableViewDelegate {}
