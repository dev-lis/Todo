//
//  ___FILEBASENAME___Presenter.swift
//  ___PACKAGENAME___
//
//  ___FILEHEADER___
//

import Foundation

protocol I___VARIABLE_productName:identifier___Presenter {
    func viewDidLoad()
}

final class ___VARIABLE_productName:identifier___Presenter {

    weak var view: I___VARIABLE_productName:identifier___View?

    private var interactor: I___VARIABLE_productName:identifier___InteractorInput?
    private var router: I___VARIABLE_productName:identifier___Router?

    init(interactor: I___VARIABLE_productName:identifier___InteractorInput,
         router: I___VARIABLE_productName:identifier___Router) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - I___VARIABLE_productName:identifier___Presenter

extension ___VARIABLE_productName:identifier___Presenter: I___VARIABLE_productName:identifier___Presenter {
    func viewDidLoad() {}
}

// MARK: - I___VARIABLE_productName:identifier___InteractorOutput

extension ___VARIABLE_productName:identifier___Presenter: I___VARIABLE_productName:identifier___InteractorOutput {}
