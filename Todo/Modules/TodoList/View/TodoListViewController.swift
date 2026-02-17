//
//  TodoListViewController.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import AppUIKit
import UIKit

// sourcery: AutoMockable
protocol ITodoListView: AnyObject {
    func updateList(items: [TodoDisplayItem])
    func updateCounter(count: Int)
}

final class TodoListViewController: UIViewController {

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = L.searchPlaceholder.localized()
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.barTintColor = UI.Color.baseBackground
        controller.searchBar.backgroundColor = UI.Color.baseBackground
        controller.searchBar.tintColor = UI.Color.textRegular
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
        view.backgroundColor = UI.Color.baseBackground
        title = L.tasksTitle.localized()

        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupTableView()
        presenter.viewDidLoad()
    }

    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UI.Color.baseBackground
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UI.Color.textRegular,
            .font: UI.Font.header
        ]
        appearance.titleTextAttributes = [.foregroundColor: UI.Color.textRegular]

        let navBar = navigationController?.navigationBar
        navBar?.prefersLargeTitles = true
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        navBar?.compactAppearance = appearance
        navBar?.tintColor = UI.Color.textRegular

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
    func updateList(items: [TodoDisplayItem]) {
        DispatchQueue.main.async {
            self.applySnapshot(items: items)
        }
    }

    func updateCounter(count: Int) {
        DispatchQueue.main.async {
            self.footerView.setCounterText(L.taskCount.plural(count: count))
        }
    }
}

// MARK: - UITableViewDelegate

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectTodo(at: indexPath.row)
    }
}
