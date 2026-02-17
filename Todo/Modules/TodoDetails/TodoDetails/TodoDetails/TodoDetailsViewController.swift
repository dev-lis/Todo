//
//  TodoDetailsViewControllerViewController.swift
//  Todo
//
//  
//  TodoDetailsViewController.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import UIKit

protocol ITodoDetailsView: AnyObject {}

final class TodoDetailsViewController: UIViewController {

    var presenter: ITodoDetailsPresenter

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
    }
}

private extension TodoDetailsViewController {
    func setupUI() {
        presenter.viewDidLoad()
    }
}

// MARK: - ITodoDetailsView

extension TodoDetailsViewController: ITodoDetailsView {

}
