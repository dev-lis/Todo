//  
//  TodoDetailsRouter.swift
//  Todo
//
//  Created by Aleksandr Lis on 18.02.2026.
//
//

import UIKit

protocol ITodoDetailsRouter {}

final class TodoDetailsRouter {

    weak var viewController: UIViewController?
}

// MARK: - ITodoDetailsRouter

extension TodoDetailsRouter: ITodoDetailsRouter {}
