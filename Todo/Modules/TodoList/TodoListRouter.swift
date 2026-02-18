//  
//  TodoListRouter.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//
//

import UIKit

// sourcery: AutoMockable
protocol ITodoListRouter {
    func shareTodo(item: TodoDisplayItem)
}

final class TodoListRouter {

    weak var viewController: UIViewController?
}

// MARK: - ITodoListRouter

extension TodoListRouter: ITodoListRouter {
    func shareTodo(item: TodoDisplayItem) {
        let text = [item.title, item.description ?? ""].filter { !$0.isEmpty }.joined(separator: "\n\n")
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        guard let source = viewController else { return }
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = source.view
            popover.sourceRect = CGRect(x: source.view.bounds.midX, y: source.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        var top = source
        while let presented = top.presentedViewController { top = presented }
        top.present(activityVC, animated: true)
    }
}
