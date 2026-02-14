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

final class TodoListViewController: UIViewController, ITodoListView {

    var presenter: ITodoListPresenter

    init(presenter: ITodoListPresenter) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension TodoListViewController {
    func setupUI() {}
}

// MARK: - ITodoListView

extension TodoListViewController: ITodoListView {
    
}
