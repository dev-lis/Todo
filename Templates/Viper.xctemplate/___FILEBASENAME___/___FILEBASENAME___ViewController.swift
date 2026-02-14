//
//  ___FILEBASENAME___ViewController.swift
//  ___PACKAGENAME___
//
//  ___FILEHEADER___
//

import UIKit

protocol I___VARIABLE_productName:identifier___View: AnyObject {}

final class ___VARIABLE_productName:identifier___ViewController: UIViewController {

    var presenter: I___VARIABLE_productName:identifier___Presenter

    init(presenter: I___VARIABLE_productName:identifier___Presenter) {
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

private extension ___VARIABLE_productName:identifier___ViewController {
    func setupUI() {
        presenter.viewDidLoad()
    }
}

// MARK: - I___VARIABLE_productName:identifier___View

extension ___VARIABLE_productName:identifier___ViewController: I___VARIABLE_productName:identifier___View {
    
}
