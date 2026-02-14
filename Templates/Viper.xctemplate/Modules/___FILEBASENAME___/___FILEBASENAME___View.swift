//
//  ___FILEBASENAME___ViewController.swift
//  ___PACKAGENAME___
//
//  ___FILEHEADER___
//

import UIKit

protocol I___VARIABLE_productName:identifier___View: AnyObject {}

final class ___VARIABLE_productName:identifier___ViewController: UIViewController, I___VARIABLE_productName:identifier___View {

    var presenter: I___VARIABLE_productName:identifier___Presenter

    init(presenter: I___VARIABLE_productName:identifier___Presenter) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension ___VARIABLE_productName:identifier___ViewController {
    func setupUI() {}
}

// MARK: - I___VARIABLE_productName:identifier___View

extension ___VARIABLE_productName:identifier___ViewController: I___VARIABLE_productName:identifier___View {
    
}
