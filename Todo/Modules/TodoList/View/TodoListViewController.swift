//
//  TodoListViewController.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//

import UIKit

protocol ITodoListView: AnyObject {
    func update(items: [TodoDisplayItem])
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

    private lazy var footerView: TodoListFooterView = {
        let view = TodoListFooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private enum Section: Hashable {
        case main
    }

    private var dataSource: UITableViewDiffableDataSource<Section, TodoDisplayItem>!

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
        view.addSubview(footerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),

            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 84)
        ])
    }

    func setupTableView() {
        dataSource = UITableViewDiffableDataSource<Section, TodoDisplayItem>(tableView: tableView) { tableView, _, item in
            let cell = tableView.dequeueCell(with: TodoListCell.self)
            cell.configure(with: item)
            return cell
        }
    }

    func applySnapshot(items: [TodoDisplayItem], animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TodoDisplayItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - ITodoListView

extension TodoListViewController: ITodoListView {
    func update(items: [TodoDisplayItem]) {
        DispatchQueue.main.async {
            self.applySnapshot(items: items)
            self.footerView.setCounterText("\(items.count) Задач")
        }
    }
}

// MARK: - UITableViewDelegate

extension TodoListViewController: UITableViewDelegate {}
