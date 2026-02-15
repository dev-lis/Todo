//
//  UIColor+Todo.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import UIKit

extension UIColor {

    static let todoBackground = UIColor(hex: 0x040404)
    static let todoText = UIColor(hex: 0xF4F4F4)
    static let todoSearchBackground = UIColor(hex: 0x272729)
    static let todoStroke = UIColor(hex: 0x4D555E)
    static let todoAccent = UIColor(hex: 0xFED702)

    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255
        let green = CGFloat((hex >> 8) & 0xFF) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
