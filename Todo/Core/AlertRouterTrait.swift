//
//  AlertRouterTrait.swift
//  Todo
//

import UIKit

protocol AlertRouterTrait: AnyObject {
    var viewController: UIViewController? { get }
}

extension AlertRouterTrait {
    func showAlert(
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        actions: [UIAlertAction]
    ) {
        DispatchQueue.main.async {
            guard !actions.isEmpty else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            actions.forEach { alert.addAction($0) }
            self.present(alert)
        }
    }

    func showAlert(
        title: String? = nil,
        message: String?,
        okTitle: String = "OK",
        onOk: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            let action = UIAlertAction(title: okTitle, style: .default) { _ in onOk?() }
            self.showAlert(title: title, message: message, actions: [action])
        }
    }

    func showConfirmationAlert(
        title: String? = nil,
        message: String?,
        confirmTitle: String = "OK",
        cancelTitle: String = "Cancel",
        confirmStyle: UIAlertAction.Style = .default,
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            let confirm = UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in onConfirm() }
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { _ in onCancel?() }
            self.showAlert(title: title, message: message, actions: [cancel, confirm])
        }
    }

    func showDestructiveAlert(
        title: String? = nil,
        message: String?,
        destructiveTitle: String,
        cancelTitle: String = "Cancel",
        onDestructive: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            self.showConfirmationAlert(
                title: title,
                message: message,
                confirmTitle: destructiveTitle,
                cancelTitle: cancelTitle,
                confirmStyle: .destructive,
                onConfirm: onDestructive,
                onCancel: onCancel
            )
        }
    }

    private func present(_ viewController: UIViewController) {
        DispatchQueue.main.async {
            guard let source = self.viewController else { return }
            var top = source
            while let presented = top.presentedViewController { top = presented }
            top.present(viewController, animated: true)
        }
    }
}
