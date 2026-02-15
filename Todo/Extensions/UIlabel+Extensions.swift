//
//  UIlabel+Extensions.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import UIKit

extension UILabel {
    var isStrikethrough: Bool {
        get {
            guard let attributes = attributedText?.attributes(at: 0, effectiveRange: nil) else { return false }
            return (attributes[.strikethroughStyle] as? Int) == NSUnderlineStyle.single.rawValue
        }
        set {
            guard let text = text else { return }
            let attributes: [NSAttributedString.Key: Any] = newValue ? [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: textColor ?? .label
            ] : [.foregroundColor: textColor ?? .label]
            attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
}
