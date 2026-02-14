//
//  ClassName.swift
//  Todo
//
//  Created by Aleksandr on 15.02.2026.
//

import Foundation

public protocol ClassName {
    static var className: String { get }
    var className: String { get }
}

public extension ClassName {
    static var className: String {
        String(describing: self)
    }

    var className: String {
        type(of: self).className
    }
}

extension NSObject: ClassName {}
