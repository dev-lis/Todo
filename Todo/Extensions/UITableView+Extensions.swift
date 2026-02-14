//
//  UITableView+Extensions.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//

import UIKit

public extension UITableView {

    func registerCell<T: UITableViewCell>(type: T.Type) {
        register(type.self, forCellReuseIdentifier: type.className)
    }

    func registerCells<T: UITableViewCell>(types: [T.Type]) {
        types.forEach { registerCell(type: $0) }
    }

    // swiftlint:disable force_cast
    func dequeueCell<T: UITableViewCell>(with type: T.Type) -> T {
        if let cell = dequeueReusableCell(withIdentifier: type.className) as? T {
            return cell
        }
        registerCell(type: type)
        return dequeueReusableCell(withIdentifier: type.className) as! T
    }
    // swiftlint:enable force_cast
}
