//
//  TodoListViewViewController.swift
//  Todo
//
//  
//  TodoListView.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//
//

import UIKit

protocol ITodoListView: AnyObject {}

final class TodoListViewController: UIViewController {

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

private extension TodoListViewController {
    func setupUI() {
        presenter.viewDidLoad()
        view.backgroundColor = .yellow
    }
}

// MARK: - ITodoListView

extension TodoListViewController: ITodoListView {}
