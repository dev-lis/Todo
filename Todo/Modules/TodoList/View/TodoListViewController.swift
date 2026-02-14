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

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Поиск"
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.barTintColor = .todoBackground
        controller.searchBar.backgroundColor = .todoBackground
        controller.searchBar.tintColor = .todoText
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
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
}

// MARK: - Setup

private extension TodoListViewController {
    func setupUI() {
        view.backgroundColor = .todoBackground
        title = "Задачи"

        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupTableView()
        presenter.viewDidLoad()
    }

    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .todoBackground
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.todoText,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.todoText]

        let navBar = navigationController?.navigationBar
        navBar?.prefersLargeTitles = true
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        navBar?.compactAppearance = appearance
        navBar?.tintColor = .todoText

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(footerDivider)
        view.addSubview(footerBackgroundView)
        footerBackgroundView.addSubview(footerBlurView)
        footerBackgroundView.addSubview(tasksCountLabel)
        footerBackgroundView.addSubview(addButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
        dataSource = UITableViewDiffableDataSource<Section, TodoItemDisplay>(tableView: tableView) { tableView, _, item in
            let cell = tableView.dequeueCell(with: TodoListCell.self)
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
